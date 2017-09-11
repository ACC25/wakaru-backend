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

  def self.get_categories
    Statistic.new.categories_breakdown
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
    binding.pry
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
                                                                                      tones[:document_tone][:tone_categories][0][:tones][4][:score])
                  )
  end

  def self.calculate_dissatisfaction(enjoyment_score, extraversion, sadness)
    enjoyment_score - extraversion * sadness
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
