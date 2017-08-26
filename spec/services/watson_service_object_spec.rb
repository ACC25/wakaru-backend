require 'rails_helper'

describe "watson object can return json information" do

  before(:each) do
    @text = "A string of words to send to Watson!!!!!#$%^"
    @watson = WatsonService.new(@text)
  end
  it "can be initialized and attributes called" do
    expect(@watson.text).to eq(@text)
  end

  it "can communicate with IBM watson" do
    expect(@watson.analyze_tone).to eq()
  end
end
