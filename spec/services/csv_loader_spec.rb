require 'rails_helper'

describe "csv loader can iterate over a csv file" do
  it "can load a csv and call the path attribute" do
    path = 'spec/test_files/Warranty Query - Good Outcome:Good Tone.csv'
    loader = CsvLoader.new(path)
    expect(loader.path).to eq(path)
  end
  it "can load csv files and create tone respones objects" do
    path = 'spec/test_files/Warranty Query - Good Outcome:Good Tone.csv'
    loader = CsvLoader.new(path)
    expect(loader.load_tone_baseline.length).to eq(1)
  end
end
