require 'rails_helper'

describe "GET categories" do
  it "returns category breakdown" do
      company = create(:company, name: "User", password: "password")
      good_good_response_1 = Response.create!(company_id: company.id, category: 0, domain: 0, disgust: 0.020028, fear: 0.02473, joy: 0.074382, sadness: 0.1019232, anger: 0.059976, openness: 0.119831, conscientiousness: 0.99957, extraversion: 0.607163, agreeableness: 0.92923, emotional_range: 0.947887, enjoyment_score: 0.814108, big_five_score: 3.597, dissatisfaction_score: 1.198)
      good_good_response_2 = Response.create(company_id: company.id, category: 0, domain: 0, disgust: 0.035028, fear: 0.007473, joy: 0.664382, sadness: 0.09232, anger: 0.050176, openness: 0.290831, conscientiousness: 0.99857, extraversion: 0.938163, agreeableness: 0.99123, emotional_range: 0.878987, enjoyment_score: 1.0275, big_five_score: 3.285, dissatisfaction_score: 0.858)
      good_good_response_3 = Response.create(company_id: company.id, category: 1, domain: 0, disgust: 0.035028, fear: 0.007473, joy: 0.664382, sadness: 0.09232, anger: 0.050176, openness: 0.290831, conscientiousness: 0.99857, extraversion: 0.938163, agreeableness: 0.99123, emotional_range: 0.878987, enjoyment_score: 0.6275, big_five_score: 3.5085, dissatisfaction_score: 0.678)
      good_good_response_3 = Response.create(company_id: company.id, category: 1, domain: 0, disgust: 0.035028, fear: 0.007473, joy: 0.664382, sadness: 0.09232, anger: 0.050176, openness: 0.290831, conscientiousness: 0.99857, extraversion: 0.938163, agreeableness: 0.99123, emotional_range: 0.878987, enjoyment_score: 0.39275, big_five_score: 2.2085, dissatisfaction_score: 0.719)
      bad_bad_response_1 = Response.create(company_id: company.id, category: 2, domain: 0, disgust: 0.058420909, fear: 0.042893318, joy: 0.216413909, sadness: 0.258661545, anger: 0.085502864, openness: 0.273824, conscientiousness: 0.778441636, extraversion: 0.422372, agreeableness: 0.653384318, emotional_range: 0.1622277273, enjoyment_score: 0.161, big_five_score: 2.83, dissatisfaction_score: 0.350)
      bad_bad_response_2 = Response.create(company_id: company.id, category: 2, domain: 0, disgust: 0.038420909, fear: 0.052893318, joy: 0.286413909, sadness: 0.558661545, anger: 0.105502864, openness: 0.193824, conscientiousness: 0.478441636, extraversion: 0.422372, agreeableness: 0.653384318, emotional_range: 0.242277273, enjoyment_score: 0.188, big_five_score: 3.00, dissatisfaction_score: 0.550)

      user = {
        username: company.name,
        password: company.password
      }

      get '/api/v1/session', :params => user

      expect(response).to be_success

      reply = JSON.parse(response.body)

      email = {
        token: reply["token"]
      }

      get "/api/v1/category", :params => email

      expect(response).to be_success

      scores = JSON.parse(response.body)
      expect(scores[0]["y"]).to eq(33.333)
      expect(scores[1]["y"]).to eq(33.333)
      expect(scores[2]["y"]).to eq(33.333)
  end

  it "returns uneven breakdown correctly" do
    company = create(:company, name: "User", password: "password")
    good_good_response_1 = Response.create!(company_id: company.id, category: 0, domain: 0, disgust: 0.020028, fear: 0.02473, joy: 0.074382, sadness: 0.1019232, anger: 0.059976, openness: 0.119831, conscientiousness: 0.99957, extraversion: 0.607163, agreeableness: 0.92923, emotional_range: 0.947887, enjoyment_score: 0.814108, big_five_score: 3.597, dissatisfaction_score: 1.198)
    good_good_response_2 = Response.create(company_id: company.id, category: 0, domain: 0, disgust: 0.035028, fear: 0.007473, joy: 0.664382, sadness: 0.09232, anger: 0.050176, openness: 0.290831, conscientiousness: 0.99857, extraversion: 0.938163, agreeableness: 0.99123, emotional_range: 0.878987, enjoyment_score: 1.0275, big_five_score: 3.285, dissatisfaction_score: 0.858)
    good_good_response_3 = Response.create(company_id: company.id, category: 1, domain: 0, disgust: 0.035028, fear: 0.007473, joy: 0.664382, sadness: 0.09232, anger: 0.050176, openness: 0.290831, conscientiousness: 0.99857, extraversion: 0.938163, agreeableness: 0.99123, emotional_range: 0.878987, enjoyment_score: 0.6275, big_five_score: 3.5085, dissatisfaction_score: 0.678)
    good_good_response_3 = Response.create(company_id: company.id, category: 1, domain: 0, disgust: 0.035028, fear: 0.007473, joy: 0.664382, sadness: 0.09232, anger: 0.050176, openness: 0.290831, conscientiousness: 0.99857, extraversion: 0.938163, agreeableness: 0.99123, emotional_range: 0.878987, enjoyment_score: 0.39275, big_five_score: 2.2085, dissatisfaction_score: 0.719)
    bad_bad_response_1 = Response.create(company_id: company.id, category: 2, domain: 0, disgust: 0.058420909, fear: 0.042893318, joy: 0.216413909, sadness: 0.258661545, anger: 0.085502864, openness: 0.273824, conscientiousness: 0.778441636, extraversion: 0.422372, agreeableness: 0.653384318, emotional_range: 0.1622277273, enjoyment_score: 0.161, big_five_score: 2.83, dissatisfaction_score: 0.350)
    bad_bad_response_2 = Response.create(company_id: company.id, category: 2, domain: 0, disgust: 0.038420909, fear: 0.052893318, joy: 0.286413909, sadness: 0.558661545, anger: 0.105502864, openness: 0.193824, conscientiousness: 0.478441636, extraversion: 0.422372, agreeableness: 0.653384318, emotional_range: 0.242277273, enjoyment_score: 0.188, big_five_score: 3.00, dissatisfaction_score: 0.550)
    bad_bad_response_2 = Response.create(company_id: company.id, category: 2, domain: 0, disgust: 0.038420909, fear: 0.052893318, joy: 0.286413909, sadness: 0.558661545, anger: 0.105502864, openness: 0.193824, conscientiousness: 0.478441636, extraversion: 0.422372, agreeableness: 0.653384318, emotional_range: 0.242277273, enjoyment_score: 0.188, big_five_score: 3.00, dissatisfaction_score: 0.550)
    bad_bad_response_2 = Response.create(company_id: company.id, category: 2, domain: 0, disgust: 0.038420909, fear: 0.052893318, joy: 0.286413909, sadness: 0.558661545, anger: 0.105502864, openness: 0.193824, conscientiousness: 0.478441636, extraversion: 0.422372, agreeableness: 0.653384318, emotional_range: 0.242277273, enjoyment_score: 0.188, big_five_score: 3.00, dissatisfaction_score: 0.550)
    bad_bad_response_2 = Response.create(company_id: company.id, category: 2, domain: 0, disgust: 0.038420909, fear: 0.052893318, joy: 0.286413909, sadness: 0.558661545, anger: 0.105502864, openness: 0.193824, conscientiousness: 0.478441636, extraversion: 0.422372, agreeableness: 0.653384318, emotional_range: 0.242277273, enjoyment_score: 0.188, big_five_score: 3.00, dissatisfaction_score: 0.550)
    bad_bad_response_2 = Response.create(company_id: company.id, category: 2, domain: 0, disgust: 0.038420909, fear: 0.052893318, joy: 0.286413909, sadness: 0.558661545, anger: 0.105502864, openness: 0.193824, conscientiousness: 0.478441636, extraversion: 0.422372, agreeableness: 0.653384318, emotional_range: 0.242277273, enjoyment_score: 0.188, big_five_score: 3.00, dissatisfaction_score: 0.550)
    bad_bad_response_2 = Response.create(company_id: company.id, category: 2, domain: 0, disgust: 0.038420909, fear: 0.052893318, joy: 0.286413909, sadness: 0.558661545, anger: 0.105502864, openness: 0.193824, conscientiousness: 0.478441636, extraversion: 0.422372, agreeableness: 0.653384318, emotional_range: 0.242277273, enjoyment_score: 0.188, big_five_score: 3.00, dissatisfaction_score: 0.550)

    user = {
      username: company.name,
      password: company.password
    }

    get '/api/v1/session', :params => user

    expect(response).to be_success

    reply = JSON.parse(response.body)

    email = {
      token: reply["token"]
    }

    get "/api/v1/category", :params => email

    expect(response).to be_success

    scores = JSON.parse(response.body)
    expect(scores[0]["y"]).to eq(18.182)
    expect(scores[1]["y"]).to eq(18.182)
    expect(scores[2]["y"]).to eq(63.636)
  end
end
