require 'rails_helper'

describe "csv loader can iterate over a csv file" do

  it "can load a csv and call the path attribute" do
    path = 'spec/test_files/Warranty Query - Good Outcome:Good Tone.csv'
    loader = CsvLoader.new(path)
    expect(loader.path).to eq(path)
  end

  it "can load csv files and create tone respones objects" do
    path = 'spec/test_files/warranty_query_good_outcome_good_tone.csv'
    loader = CsvLoader.new(path)
    expect(loader.load_tone_baseline.length).to eq(3)
  end

  it "can detect when there is profanity in the csv" do
    path = 'spec/test_files/profanity.csv'
    loader = CsvLoader.new(path)
    expect(loader.load_tone_baseline.length).to eq(0)
  end

  xit "can pass information to watson tone service" do
    path = 'spec/test_files/warranty_query_good_outcome_good_tone.csv'
    loader = CsvLoader.new(path).load_tone_baseline[0]

    response = WatsonService.new(loader.response).analyze_tone

    expect(response.length).to eq(2)
  end

  xit "can pass information to watson tone_chat service" do
    path = 'spec/test_files/warranty_query_good_outcome_good_tone.csv'
    loader = CsvLoader.new(path).load_tone_baseline[0]

    response = WatsonService.new(loader.response).analyze_tone_chat(loader.utterances)
    expect(response.length).to eq(1)
  end

  # it "can enter information into the db" do
  #   path = 'spec/test_files/warranty_query_good_outcome_good_tone.csv'
  #   loader = CsvLoader.new(path).load_tone_baseline[0]
  #
  #   tone_response = WatsonService.new(loader.response).analyze_tone
  #   tone_chat_response = WatsonService.new(loader.response).analyze_tone_chat(loader.utterances)
  # end
end
