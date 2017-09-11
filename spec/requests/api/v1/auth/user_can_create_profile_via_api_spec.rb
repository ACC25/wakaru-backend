require 'rails_helper'

describe "user can create account with api" do
  it "can receive a form for user creation" do
    user = {
      "username": "wakaru",
      "password": "something"
    }

    post '/api/v1/session', :params => user

    expect(response).to be_success

    reply = JSON.parse(response.body)

    expect(reply["token"].class).to eq(String)

    decoded_token = JWT.decode(reply["token"], ENV['rails_secret_key_base'], true, { :algorithm => 'HS256' })

    expect(decoded_token[0]["user_id"].class).to eq(Fixnum)
  end

  it "shows error message when user cannot be created" do
    user = {
      "username": "wakaru"
    }

    post '/api/v1/session', :params => user

    reply = JSON.parse(response.body)

    expect(reply["error"]).to eq("Account could not be created.")
  end
end
