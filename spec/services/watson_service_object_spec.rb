require 'rails_helper'

describe "watson object can return json information" do
  it "can be initialized and attributes called" do
    text = "A string of words to send to Watson"
    watson = WatsonService.new(text)
    expect(watson.text).to eq(text)
  end
end
