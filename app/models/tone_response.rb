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
          "text": @question,
          "user": "customer"
        },
        {
          "text": @response,
          "user": "agent"
        }
      ]
    }
  end

  def nlp_params
    {
      "text": @response,
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

end
