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
    count = 0
    responses.each do |response|
      watson = WatsonService.new(response.response)
      tones = watson.analyze_tone
      tone_chat = watson.analyze_tone_chat(response.utterances) if response.response.length < 500
      tone_object = db_create_tones(tones, response.question, response.response)
      tone_chat_object = db_create_tone_chat(tone_chat, tone_object.id) if tone_chat != nil
      write_to_csv(tone_object)
      puts "Created db entries for response #{count} out of #{responses.length} for category #{@category}"
      count += 1
    end
  end

  private

  def write_to_csv(tone_object)
    header = ["Category", "Domain", "Disgust", "Fear", "Joy", "Sadness", "Anger", "Openness", "Conscientiousness", "Extraversion", "Agreeableness", "Emotional Range", "Enjoyment Score", "Big 3"]
    CSV.open("db/stats/form_outcomes.csv", "a+") do |csv|
      row = CSV::Row.new(header,[])
      row["Category"] = tone_object.category
      row["Domain"] = tone_object.domain
      row["Disgust"] = tone_object.disgust
      row["Fear"] = tone_object.fear
      row["Joy"] = tone_object.joy
      row["Sadness"] = tone_object.sadness
      row["Anger"] = tone_object.anger
      row["Openness"] = tone_object.openness
      row["Conscientiousness"] = tone_object.conscientiousness
      row["Extraversion"] = tone_object.extraversion
      row["Agreeableness"] = tone_object.agreeableness
      row["Emotional Range"] = tone_object.emotional_range
      row["Enjoyment Score"] = tone_object.enjoyment_score
      row["Big 3"] = tone_object.big_five_score
      csv << row
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
                          domain: @domain,
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
                                                          tones[:document_tone][:tone_categories][2][:tones][4][:score]))
  end

  def db_create_tone_chat(tone_chat, foreign_key)
    input = BaseUtterance.create!(base_response_id: foreign_key,
                          question_tone_name: tone_chat[:utterances_tone][0][:tones][0][:tone_id],
                          question_tone: tone_chat[:utterances_tone][0][:tones][0][:score],
                          question_tone_name_two: tone_chat[:utterances_tone][0][:tones][1][:tone_id],
                          question_tone_two: tone_chat[:utterances_tone][0][:tones][1][:score],
                          response_tone_name: validate_tone_chat_one_name(tone_chat),
                          response_tone: validate_tone_chat_one(tone_chat),
                          response_tone_name_two: validate_tone_chat_two_name(tone_chat),
                          response_tone_two: validate_tone_chat_two(tone_chat))
  end

  def calculate_big5(openness, conscientiousness, extraversion, agreeableness, emotional_range)
    metrics = [openness, conscientiousness, extraversion, agreeableness, emotional_range]
    metrics.reduce(:+)
  end

  def calculate_enjoyment(joy, sadness, openness, conscientiousness, extraversion, agreeableness)
    metrics = [extraversion, agreeableness]
    metrics.reduce(:+) * joy
  end

  def validate_tone_chat_two_name(tone_chat)
    if tone_chat[:utterances_tone][1][:tones].length > 1
      tone_chat[:utterances_tone][1][:tones][1][:tone_id]
    end
  end

  def validate_tone_chat_two(tone_chat)
    if tone_chat[:utterances_tone][1][:tones].length > 1
      tone_chat[:utterances_tone][1][:tones][1][:score]
    end
  end

  def validate_tone_chat_one_name(tone_chat)
    if tone_chat[:utterances_tone][1][:tones].length > 1
      tone_chat[:utterances_tone][1][:tones][0][:tone_id]
    end
  end

  def validate_tone_chat_one(tone_chat)
    if tone_chat[:utterances_tone][1][:tones].length > 1
      tone_chat[:utterances_tone][1][:tones][0][:score]
    end
  end

end

# (path, category, domain)
# category 0 = good_outcome_good_tone
# category 1 = bad_outcome_good_tone
# category 2 = bad_outcome_bad_tone
# domain 0 = public results
# domain 1 = private results
# domain 2 = professional results

SeedData.new("db/stats/responses/Warranty Query - Good Outcome%2FGood Tone.csv", 0, 0).load_fixture
SeedData.new("db/stats/responses/Warranty Query - Bad Outcome%2FGood Tone.csv", 1, 0).load_fixture
SeedData.new("db/stats/responses/Warranty Query - Bad Outcome%2FBad Tone.csv", 2, 0).load_fixture
SeedData.new("db/stats/responses/Wait Times Query - Good Outcome%2FGood Tone.csv", 0, 0).load_fixture
SeedData.new("db/stats/responses/Wait Times Query - Bad Outcome%2FGood Tone.csv", 1, 0).load_fixture
SeedData.new("db/stats/responses/Wait Times Query - Bad Outcome%2FBad Tone.csv", 2, 0).load_fixture
SeedData.new("db/stats/responses/Surfboard Inventory Query - Good Outcome%2FGood Tone.csv", 0, 1).load_fixture
SeedData.new("db/stats/responses/Surfboard Inventory Query - Bad Outcome%2F Good Tone.csv", 1, 1).load_fixture
SeedData.new("db/stats/responses/Surfboard Inventory Query - Bad Outcome%2FBad Tone.csv", 2, 1).load_fixture
SeedData.new("db/stats/responses/Accessories Inventory Query - Good Outcome%2FGood Tone.csv", 0, 1).load_fixture
SeedData.new("db/stats/responses/Accessories Inventory Query - Bad Outcome%2FGood Tone.csv", 1, 1).load_fixture
SeedData.new("db/stats/responses/Accessories Inventory Query - Bad Outcome%2FBad Tone.csv", 2, 1).load_fixture
