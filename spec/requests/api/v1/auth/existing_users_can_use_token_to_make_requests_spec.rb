require 'rails_helper'

describe "users can use a valid token for multiple calls" do
  it "allows users with a valid token to get email breakdown" do
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

    get "/api/v1/category", :params => reply

    expect(response).to be_success

    scores = JSON.parse(response.body)

    expect(scores[0]["y"]).to eq(33.333)
    expect(scores[1]["y"]).to eq(33.333)
    expect(scores[2]["y"]).to eq(33.333)
  end

  it "allows users with a valid token to use email classification and topword features" do
    company = create(:company, name: "username", password: "password")
    text = ["Hi Customer one, I've checked with our warehouse staff and we do have one left in stock! I've asked them to put it aside for now, depending on how you want to proceed. You can either pick it up at our store or we can ship it (the cost would be the same as if you bought it online). Just let me know -- it's yours either way. Thank you for taking the time to email us.", "Hi Customer One, Our site is correct, we are out of stock, but we would be happy to order you a bag from one of our distributors. There shouldn't be any issue getting it here before you leave on your trip. Thank you for reaching out!", "Hi, Customer One! We're thrilled that your friend recommended us and we hope he enjoys his new board for many years to come! We would be happy to meet with you next week to discuss your design ideas. Would Tuesday at 1300 work? The consultation should take 30 minutes at most. Our designers are excited to get started on your project! Let us know if another time works better for you or if you need any more information."]
    good_good_response_1 = Response.create!(response_text: text.sample,company_id: company.id, category: 0, domain: 0, disgust: 0.020028, fear: 0.02473, joy: 0.074382, sadness: 0.1019232, anger: 0.059976, openness: 0.119831, conscientiousness: 0.99957, extraversion: 0.607163, agreeableness: 0.92923, emotional_range: 0.947887, enjoyment_score: 0.814108, big_five_score: 3.597, dissatisfaction_score: 1.198)
    good_good_response_2 = Response.create(response_text: text.sample,company_id: company.id, category: 0, domain: 0, disgust: 0.035028, fear: 0.007473, joy: 0.664382, sadness: 0.09232, anger: 0.050176, openness: 0.290831, conscientiousness: 0.99857, extraversion: 0.938163, agreeableness: 0.99123, emotional_range: 0.878987, enjoyment_score: 1.0275, big_five_score: 3.285, dissatisfaction_score: 0.858)
    good_good_response_2 = Response.create(response_text: text.sample,company_id: company.id, category: 0, domain: 0, disgust: 0.035028, fear: 0.007473, joy: 0.664382, sadness: 0.09232, anger: 0.050176, openness: 0.290831, conscientiousness: 0.99857, extraversion: 0.938163, agreeableness: 0.99123, emotional_range: 0.878987, enjoyment_score: 1.0275, big_five_score: 3.285, dissatisfaction_score: 0.858)
    good_good_response_3 = Response.create(response_text: text.sample,company_id: company.id, category: 1, domain: 0, disgust: 0.035028, fear: 0.007473, joy: 0.664382, sadness: 0.09232, anger: 0.050176, openness: 0.290831, conscientiousness: 0.99857, extraversion: 0.938163, agreeableness: 0.99123, emotional_range: 0.878987, enjoyment_score: 0.6275, big_five_score: 3.5085, dissatisfaction_score: 0.678)
    good_good_response_3 = Response.create(response_text: text.sample,company_id: company.id, category: 1, domain: 0, disgust: 0.035028, fear: 0.007473, joy: 0.664382, sadness: 0.09232, anger: 0.050176, openness: 0.290831, conscientiousness: 0.99857, extraversion: 0.938163, agreeableness: 0.99123, emotional_range: 0.878987, enjoyment_score: 0.6275, big_five_score: 3.5085, dissatisfaction_score: 0.678)
    good_good_response_3 = Response.create(response_text: text.sample,company_id: company.id, category: 1, domain: 0, disgust: 0.035028, fear: 0.007473, joy: 0.664382, sadness: 0.09232, anger: 0.050176, openness: 0.290831, conscientiousness: 0.99857, extraversion: 0.938163, agreeableness: 0.99123, emotional_range: 0.878987, enjoyment_score: 0.39275, big_five_score: 2.2085, dissatisfaction_score: 0.719)
    bad_bad_response_1 = Response.create(response_text: text.sample,company_id: company.id, category: 2, domain: 0, disgust: 0.058420909, fear: 0.042893318, joy: 0.216413909, sadness: 0.258661545, anger: 0.085502864, openness: 0.273824, conscientiousness: 0.778441636, extraversion: 0.422372, agreeableness: 0.653384318, emotional_range: 0.1622277273, enjoyment_score: 0.161, big_five_score: 2.83, dissatisfaction_score: 0.350)
    bad_bad_response_2 = Response.create(response_text: text.sample,company_id: company.id, category: 2, domain: 0, disgust: 0.038420909, fear: 0.052893318, joy: 0.286413909, sadness: 0.558661545, anger: 0.105502864, openness: 0.193824, conscientiousness: 0.478441636, extraversion: 0.422372, agreeableness: 0.653384318, emotional_range: 0.242277273, enjoyment_score: 0.188, big_five_score: 3.00, dissatisfaction_score: 0.550)


    user = {
      username: company.name,
      password: company.password
    }

    get '/api/v1/session', :params => user

    expect(response).to be_success

    reply = JSON.parse(response.body)

    email = {
      token: reply["token"],
      domain: 0,
      question: "Hello, I want to know about your store, give me some information why don't you.",
      response: "Hello there customer one! We are a company of many products. We have products that span the world, from toys to spaceships. Are you interested in a specific type of product? I'd be happy to go over our product line with you if you want. Have a nice day."
    }

    post "/api/v1/category", :params => email

    expect(response).to be_success

    scores = JSON.parse(response.body)

    expect(scores[0][0]["y"]).to eq(33.33333333333333)
    expect(scores[0][2]["y"]).to eq(100.0)

    email = {
      token: reply["token"],
      category: 0
    }

    get "/api/v1/top_words", :params => email

    expect(response).to be_success

    reply = JSON.parse(response.body)

    expect(reply["nouns"].class).to eq(Array)
    expect(reply["adjectives"].class).to eq(Array)
    expect(reply["keywords"].class).to eq(Array)
  end
end
