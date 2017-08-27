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

  xit "can communicate with IBM watson for nlp" do
    params = {
      "text": "It doesn't look like you purchased a warranty plan last week, but we appreciate
      how frustrating damaging a board is and we want to offer a complimentary repair.
      You can drop the board off at our shop anytime this week and we will get it back
       to you as soon as possible.",
      "features": {
        "keywords": {
          "emotion": false,
          "sentiment": true,
          "limit": 3
        },
        "entities": {
          "sentiment": true,
          "limit": 3
        }
      }
    }
    expect(@watson.analyze_nlp(params).length).to eq(4)
  end
end
