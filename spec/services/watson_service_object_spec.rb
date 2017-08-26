require 'rails_helper'

describe "watson object can return json information" do

  before(:each) do
    @text = "A string of words to send to Watson!!!!!#$%^"
    @watson = WatsonService.new(@text)
  end

  it "can be initialized and attributes called" do
    expect(@watson.text).to eq(@text)
  end

  xit "can communicate with IBM watson for tone analysis" do
    expect(@watson.analyze_tone[:document_tone].length).to eq(1)
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
    expect(@watson.analyze_tone_chat(tone_chat_input)[:utterances_tone].length).to eq(4)
  end
end
