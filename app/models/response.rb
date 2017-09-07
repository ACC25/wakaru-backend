class Response < ApplicationRecord
  belongs_to :company


  def self.find_relations(tones, user_id, domain, question, response)
    db_response = enter_db(user_id, tones, domain, question, response)
    Stat.new(db_response.id).find_my_category
  end


  private

  def self.enter_db(user_id, tones, domain, question, response)
    self.create!(company_id: user_id,
                 response_text: response,
                 question_text: question,
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
                                                 tones[:document_tone][:tone_categories][2][:tones][4][:score])
                  )
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
