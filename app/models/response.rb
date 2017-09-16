class Response < ApplicationRecord
  belongs_to :company

  def self.analyze_category(question, response, domain, category)
    tones = WatsonService.new(response).analyze_tone
    db_response = enter_db(tones, domain, question, response, category)
    stat = Statistic.new(db_response.id)
    domain == "1" ? stat.find_my_stats : stat.find_my_category
    stat
  end

  def self.top_words(category)
    text_collection = Response.where(category: category).pluck(:response_text)
    word = Word.new(text_collection)
    word.find_words
    word.top_words
  end

  def self.reformat_scores(scores, summary)
    formatted_scores = scores.map do |scores|
      scores[1][:category_0] = 0 if scores[1][:category_0] == nil
      scores[1][:category_1] = 0 if scores[1][:category_1] == nil
      scores[1][:category_2] = 0 if scores[1][:category_2] == nil
      object_1 = {x: 0, y: scores[1][:category_0].round}
      object_2 = {x: 1, y: scores[1][:category_1].round}
      object_3 = {x: 2, y: scores[1][:category_2].round}
      output = [object_1, object_2, object_3]
      output
    end
    enjoyment = [summary[:enjoyment]]
    brand = [summary[:brand]]
    category = [summary[:category]]
    formatted_scores.push(enjoyment)
    formatted_scores.push(brand)
    formatted_scores.push(category)
  end

  def self.get_categories(user_id)
    Statistic.new.categories_breakdown(user_id)
  end

  def self.get_fixtures
    Response.where(domain: 1).map do |entry|
      entry.id
    end
  end

  def self.reset_category(db_id)
    stat = Statistic.new(db_id)
    stat.find_my_category
    stat
  end

  def self.reclassify
    responses = Response.where(domain: 0)
    responses.each do |response|
      stat = Statistic.new(response.id)
      stat.find_my_category
    end
  end

  private

  def self.enter_db(tones, domain, question, response, category)
    self.create!(response_text: response,
                 question_text: question,
                 category: category,
                 disgust: tones[:document_tone][:tone_categories][0][:tones][1][:score],
                 fear: tones[:document_tone][:tone_categories][0][:tones][2][:score],
                 joy: tones[:document_tone][:tone_categories][0][:tones][3][:score],
                 sadness: tones[:document_tone][:tone_categories][0][:tones][4][:score],
                 anger: tones[:document_tone][:tone_categories][0][:tones][0][:score],
                 analytical: tones[:document_tone][:tone_categories][1][:tones][0][:score],
                 confident: tones[:document_tone][:tone_categories][1][:tones][1][:score],
                 tentative: tones[:document_tone][:tone_categories][1][:tones][2][:score],
                 openness: tones[:document_tone][:tone_categories][2][:tones][0][:score],
                 conscientiousness: tones[:document_tone][:tone_categories][2][:tones][1][:score],
                 extraversion: tones[:document_tone][:tone_categories][2][:tones][2][:score],
                 agreeableness: tones[:document_tone][:tone_categories][2][:tones][3][:score],
                 emotional_range: tones[:document_tone][:tone_categories][2][:tones][4][:score],
                 domain: domain,
                 enjoyment_score: calculate_enjoyment(tones[:document_tone][:tone_categories][0][:tones][3][:score],
                                                      tones[:document_tone][:tone_categories][0][:tones][4][:score],
                                                      tones[:document_tone][:tone_categories][2][:tones][0][:score],
                                                      tones[:document_tone][:tone_categories][2][:tones][1][:score],
                                                      tones[:document_tone][:tone_categories][2][:tones][2][:score],
                                                      tones[:document_tone][:tone_categories][2][:tones][3][:score]),
                 big_five_score: calculate_big5(tones[:document_tone][:tone_categories][2][:tones][0][:score],
                                                 tones[:document_tone][:tone_categories][2][:tones][1][:score],
                                                 tones[:document_tone][:tone_categories][2][:tones][2][:score],
                                                 tones[:document_tone][:tone_categories][2][:tones][3][:score],
                                                 tones[:document_tone][:tone_categories][2][:tones][4][:score]),
                  dissatisfaction_score: calculate_dissatisfaction(calculate_enjoyment(tones[:document_tone][:tone_categories][0][:tones][3][:score],
                                                                                      tones[:document_tone][:tone_categories][0][:tones][4][:score],
                                                                                      tones[:document_tone][:tone_categories][2][:tones][0][:score],
                                                                                      tones[:document_tone][:tone_categories][2][:tones][1][:score],
                                                                                      tones[:document_tone][:tone_categories][2][:tones][2][:score],
                                                                                      tones[:document_tone][:tone_categories][2][:tones][3][:score]),
                                                                                      tones[:document_tone][:tone_categories][2][:tones][2][:score],
                                                                                      tones[:document_tone][:tone_categories][0][:tones][4][:score],
                                                                                      tones[:document_tone][:tone_categories][2][:tones][3][:score])
                  )
  end

  def self.calculate_dissatisfaction(enjoyment_score, extraversion, sadness, agreeableness)
    enjoyment_score - extraversion - agreeableness * sadness
  end

  def self.calculate_big5(openness, conscientiousness, extraversion, agreeableness, emotional_range)
    metrics = [conscientiousness, extraversion, agreeableness]
    metrics.reduce(:+)
  end

  def self.calculate_enjoyment(joy, sadness, openness, conscientiousness, extraversion, agreeableness)
    metrics = [extraversion, agreeableness]
    metrics.reduce(:+) * joy
  end
end
