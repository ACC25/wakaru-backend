require 'rails_helper'
require 'tone_fixtures/good_good'
require 'tone_fixtures/bad_bad'

describe "it can calculate basic functions " do

  it "can caluclate average of different domains and specific columns" do
    output_1 = Calculator.new.average_base_tone(0, "anger")
    output_2 = Calculator.new.average_base_tone(0, "joy")

    expect(output_1).to eq(0.4811)
    expect(output_2).to eq(0.407766666666667)
  end

  it "can calculate the geometric mean of domain 1 (private results) and category 0 (good outcome/good tone) tones " do
    tone_basics = Calculator.new.geometric_mean_base_tones(1, 0)
  end
end
