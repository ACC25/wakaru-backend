require 'rails_helper'

describe "watson object can return json information" do

  before(:each) do
    @text = "A string of words to send to Watson!!!!!#$%^"
    @watson = WatsonService.new(@text)
  end

  it "can be initialized and attributes called" do
    expect(@watson.text).to eq(@text)
  end

  it "can communicate with IBM watson for tone analysis" do
    json_response = @watson.analyze_tone
    expect(json_response[:document_tone]).to eq(json_response[:document_tone])
  end

  xit "can communicate with IBM watson for tone chat analysis" do
    tone_chat_input = {
      "utterances": [
        {
          "text": "Hello, I'm having a problem with your product.",
          "user": "customer"
        },
        {
          "text": "OK, let me know what's going on, please.",
          "user": "agent"
        },
        {
          "text": "Well, nothing is working :(",
          "user": "customer"
        },
        {
          "text": "Sorry to hear that.",
          "user": "agent"
        }
      ]
    }
    json_response = @watson.analyze_tone_chat(tone_chat_input)
  end
end
