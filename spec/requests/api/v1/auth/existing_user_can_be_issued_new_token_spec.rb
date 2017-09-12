require 'rails_helper'

describe "user can login with api" do
  it "can receive a form for user creation" do
    company = create(:company, name: "Existing User", password: "password")
    user = {
      "username": company.name,
      "password": company.password
    }

    get '/api/v1/session', :params => user

    expect(response).to be_success

    reply = JSON.parse(response.body)

    expect(reply["token"].class).to eq(String)

    decoded_token = JWT.decode(reply["token"], ENV['rails_secret_key_base'], true, { :algorithm => 'HS256' })

    expect(decoded_token[0]["user_id"]).to eq(company.id)
  end

  it "sends error if password is invalid" do
    company = create(:company, name: "Existing User", password: "password")
    user = {
      "username": company.name,
      "password": "wrong password"
    }

    get '/api/v1/session', :params => user

    expect(response).to be_success

    reply = JSON.parse(response.body)

    expect(reply["error"]).to eq("Invalid login credentials.")
  end

  it "sends error if password is invalid" do
    company = create(:company, name: "Existing User", password: "password")
    user = {
      "username": "wakaru",
      "password": company.password
    }

    get '/api/v1/session', :params => user

    expect(response).to be_success

    reply = JSON.parse(response.body)

    expect(reply["error"]).to eq("Invalid login credentials.")
  end
end
