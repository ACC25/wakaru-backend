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

end
