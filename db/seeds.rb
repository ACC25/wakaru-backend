class SeedData

  def initialize(path, category, domain)
    @path = path
    @category = category
    @domain = domain
  end

  def load_fixture
    responses = CsvLoader.new(@path).load_tone_baseline
    watson_tone(responses)
  end

  def watson_tone(responses)
    responses.each do |response|
      watson = WatsonService.new(response.response)
      tones = watson.analyze_tone
      tone_chat = watson.analyze_tone_chat(response.utterances)
      tone_object = db_create_tones(tones, response.question, response.response)
      tone_chat_object = db_create_tone_chat(tone_chat, tone_object.id)
    end
  end

  def db_create_tones(tones, question, response)
    input = BaseResponse.create!(response_text: response,
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
                          category: @category,
                          domain: @domain)
  end

  def db_create_tone_chat(tone_chat, foreign_key)
    input = BaseUtterance.create!(base_response_id: foreign_key,
                          question_tone_name: tone_chat[:utterances_tone][0][:tones][0][:tone_id],
                          question_tone: tone_chat[:utterances_tone][0][:tones][0][:score],
                          question_tone_name_two: tone_chat[:utterances_tone][0][:tones][1][:tone_id],
                          question_tone_two: tone_chat[:utterances_tone][0][:tones][1][:score],
                          response_tone_name: tone_chat[:utterances_tone][1][:tones][0][:tone_id],
                          response_tone: tone_chat[:utterances_tone][1][:tones][0][:score],
                          response_tone_name_two: tone_chat[:utterances_tone][1][:tones][1][:tone_id],
                          response_tone_two:tone_chat[:utterances_tone][1][:tones][1][:score])
  end

end


SeedData.new("app/assets/tone_responses/warranty_query_good_outcome_good_tone.csv", 0, 0).load_fixture
