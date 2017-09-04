class ToneResponse
  attr_reader :response,
              :question

  def initialize(question, response)
    @question = question
    @response = response
  end

  def utterances
    {
      "utterances": [
        {
          "text": question,
          "user": "customer"
        },
        {
          "text": response,
          "user": "agent"
        }
      ]
    }
  end

  def nlp_params
    {
      "text": response,
      "features": {
        "keywords": {
          "emotion": false,
          "sentiment": true,
          "limit": 3
        },
        "entities": {
          "sentiment": true,
          "limit": 3
        }
      }
    }
  end

  def analyze_category(user_id, domain)
    tones = WatsonService.new(response).analyze_tone
    Response.find_relations(tones, user_id, domain, question, response)
  end

end
#
# one_scores = {
#   disgust: tones[:document_tone][:tone_categories][0][:tones][1][:score],
#   fear: tones[:document_tone][:tone_categories][0][:tones][2][:score],
#   joy: tones[:document_tone][:tone_categories][0][:tones][3][:score],
#   sadness: tones[:document_tone][:tone_categories][0][:tones][4][:score],
#   anger: tones[:document_tone][:tone_categories][0][:tones][0][:score],
#   analytical: tones[:document_tone][:tone_categories][1][:tones][0][:score],
#   confident: tones[:document_tone][:tone_categories][1][:tones][1][:score],
#   tentative: tones[:document_tone][:tone_categories][1][:tones][2][:score],
#   openness: tones[:document_tone][:tone_categories][2][:tones][0][:score],
#   conscientiousness: tones[:document_tone][:tone_categories][2][:tones][1][:score],
#   extraversion: tones[:document_tone][:tone_categories][2][:tones][2][:score],
#   agreeableness: tones[:document_tone][:tone_categories][2][:tones][3][:score],
#   emotional_range: tones[:document_tone][:tone_categories][2][:tones][4][:score],
# }
