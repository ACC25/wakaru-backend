require 'rails_helper'

describe "it can calculate basic functions " do
  before(:each) do
    BaseResponse.create!(response_text: "response",
                          question_text: "question",
                          disgust: 0.7632,
                          fear: 0.7632,
                          joy: 0.7632,
                          sadness: 0.7632,
                          anger: 0.7632,
                          analytical: 0.7632,
                          confident: 0.7632,
                          tentative: 0.7632,
                          openness: 0.7632,
                          conscientiousness: 0.7632,
                          extraversion: 0.7632,
                          agreeableness: 0.7632,
                          emotional_range: 0.7632)
    BaseResponse.create!(response_text: "response",
                          question_text: "question",
                          disgust: 0.3433,
                          fear: 0.3433,
                          joy: 0.3433,
                          sadness: 0.3433,
                          anger: 0.3433,
                          analytical: 0.3433,
                          confident: 0.3433,
                          tentative: 0.3433,
                          openness: 0.3433,
                          conscientiousness: 0.3433,
                          extraversion: 0.3433,
                          agreeableness: 0.3433,
                          emotional_range: 0.3433)
    BaseResponse.create!(response_text: "response",
                          domain: 1,
                          question_text: "question",
                          disgust: 0.7632,
                          fear: 0.7632,
                          joy: 0.7632,
                          sadness: 0.7632,
                          anger: 0.7632,
                          analytical: 0.7632,
                          confident: 0.7632,
                          tentative: 0.7632,
                          openness: 0.7632,
                          conscientiousness: 0.7632,
                          extraversion: 0.7632,
                          agreeableness: 0.7632,
                          emotional_range: 0.7632)
    BaseResponse.create!(response_text: "response",
                          domain: 1,
                          question_text: "question",
                          disgust: 0.99888,
                          fear: 0.99888,
                          joy: 0.99888,
                          sadness: 0.99888,
                          anger: 0.99888,
                          analytical: 0.99888,
                          confident: 0.99888,
                          tentative: 0.99888,
                          openness: 0.99888,
                          conscientiousness: 0.99888,
                          extraversion: 0.99888,
                          agreeableness: 0.99888,
                          emotional_range: 0.99888)
  end

  it "can caluclate average of different domains and specific columns" do
    output_1 = Calculator.new.average_base_tone(1, "anger")
    output_2 = Calculator.new.average_base_tone(0, "joy")

    expect(output_1).to eq(0.88104)
    expect(output_2).to eq(0.55325)
  end
end
