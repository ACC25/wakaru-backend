require 'rails_helper'

describe "user can create account with api" do
  it "can send a form for user creation" do
    user = {
      "username": "wakaru",
      "password": "something"
    }
    binding.pry

    post '/api/v1/session', :params => user

    expect(response).to be_success

    reply = JSON.parse(response.body)
  end
end
