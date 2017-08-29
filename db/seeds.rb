class SeedData

  def initialize(path)
    @path = path
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
      db_create(tones, tone_chat)
    end
  end

  def db_create(tones, tone_chat)
    binding.pry
  end

end


SeedData.new("app/assets/tone_responses/warranty_query_good_outcome_good_tone.csv").load_fixture
