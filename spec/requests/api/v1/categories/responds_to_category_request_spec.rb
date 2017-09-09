require 'rails_helper'

describe "POST /api/v1/category?" do
  xit "responds with the category of the email" do
    company = create(:company)
    good_good_response_1 = Response.create!(company_id: company.id, category: 0, domain: 0, disgust: 0.020028, fear: 0.02473, joy: 0.074382, sadness: 0.1019232, anger: 0.059976, openness: 0.119831, conscientiousness: 0.99957, extraversion: 0.607163, agreeableness: 0.92923, emotional_range: 0.947887, enjoyment_score: 0.814108, big_five_score: 3.597, dissatisfaction_score: 1.198)
    good_good_response_2 = Response.create(company_id: company.id, category: 0, domain: 0, disgust: 0.035028, fear: 0.007473, joy: 0.664382, sadness: 0.09232, anger: 0.050176, openness: 0.290831, conscientiousness: 0.99857, extraversion: 0.938163, agreeableness: 0.99123, emotional_range: 0.878987, enjoyment_score: 1.0275, big_five_score: 3.285, dissatisfaction_score: 0.858)
    good_good_response_3 = Response.create(company_id: company.id, category: 1, domain: 0, disgust: 0.035028, fear: 0.007473, joy: 0.664382, sadness: 0.09232, anger: 0.050176, openness: 0.290831, conscientiousness: 0.99857, extraversion: 0.938163, agreeableness: 0.99123, emotional_range: 0.878987, enjoyment_score: 0.6275, big_five_score: 3.5085, dissatisfaction_score: 0.678)
    good_good_response_3 = Response.create(company_id: company.id, category: 1, domain: 0, disgust: 0.035028, fear: 0.007473, joy: 0.664382, sadness: 0.09232, anger: 0.050176, openness: 0.290831, conscientiousness: 0.99857, extraversion: 0.938163, agreeableness: 0.99123, emotional_range: 0.878987, enjoyment_score: 0.39275, big_five_score: 2.2085, dissatisfaction_score: 0.719)
    bad_bad_response_1 = Response.create(company_id: company.id, category: 2, domain: 0, disgust: 0.058420909, fear: 0.042893318, joy: 0.216413909, sadness: 0.258661545, anger: 0.085502864, openness: 0.273824, conscientiousness: 0.778441636, extraversion: 0.422372, agreeableness: 0.653384318, emotional_range: 0.1622277273, enjoyment_score: 0.161, big_five_score: 2.83, dissatisfaction_score: 0.350)
    bad_bad_response_2 = Response.create(company_id: company.id, category: 2, domain: 0, disgust: 0.038420909, fear: 0.052893318, joy: 0.286413909, sadness: 0.558661545, anger: 0.105502864, openness: 0.193824, conscientiousness: 0.478441636, extraversion: 0.422372, agreeableness: 0.653384318, emotional_range: 0.242277273, enjoyment_score: 0.188, big_five_score: 3.00, dissatisfaction_score: 0.550)

    email = {
      user_id: company.id,
      domain: 0,
      question: "Hello, I want to know about your store, give me some information why don't you.",
      response: "Hello there customer one! We are a company of many products. We have products that span the world, from toys to spaceships. Are you interested in a specific type of product? I'd be happy to go over our product line with you if you want. Have a nice day."
    }

    post "/api/v1/category", :params => email

    expect(response).to be_success

    scores = JSON.parse(response.body)

    expect(scores["scores"]["enjoyment_score"]["category_0"]).to eq(50.0)
    expect(scores["scores"]["enjoyment_score"]["category_3"]).to eq(75.0)
  end

  xit "responds with an appropriate category for a clearly innapropriate email" do
    company = create(:company)
    good_good_response_1 = Response.create!(company_id: company.id, category: 0, domain: 0, disgust: 0.020028, fear: 0.02473, joy: 0.074382, sadness: 0.1019232, anger: 0.059976, openness: 0.119831, conscientiousness: 0.99957, extraversion: 0.607163, agreeableness: 0.92923, emotional_range: 0.947887, enjoyment_score: 0.814108, big_five_score: 3.597, dissatisfaction_score: 1.198)
    good_good_response_2 = Response.create(company_id: company.id, category: 0, domain: 0, disgust: 0.035028, fear: 0.007473, joy: 0.664382, sadness: 0.09232, anger: 0.050176, openness: 0.290831, conscientiousness: 0.99857, extraversion: 0.938163, agreeableness: 0.99123, emotional_range: 0.878987, enjoyment_score: 1.0275, big_five_score: 3.285, dissatisfaction_score: 0.858)
    good_good_response_3 = Response.create(company_id: company.id, category: 1, domain: 0, disgust: 0.035028, fear: 0.007473, joy: 0.664382, sadness: 0.09232, anger: 0.050176, openness: 0.290831, conscientiousness: 0.99857, extraversion: 0.938163, agreeableness: 0.99123, emotional_range: 0.878987, enjoyment_score: 0.6275, big_five_score: 3.5085, dissatisfaction_score: 0.678)
    good_good_response_3 = Response.create(company_id: company.id, category: 1, domain: 0, disgust: 0.035028, fear: 0.007473, joy: 0.664382, sadness: 0.09232, anger: 0.050176, openness: 0.290831, conscientiousness: 0.99857, extraversion: 0.938163, agreeableness: 0.99123, emotional_range: 0.878987, enjoyment_score: 0.39275, big_five_score: 2.2085, dissatisfaction_score: 0.719)
    bad_bad_response_1 = Response.create(company_id: company.id, category: 2, domain: 0, disgust: 0.058420909, fear: 0.042893318, joy: 0.216413909, sadness: 0.258661545, anger: 0.085502864, openness: 0.273824, conscientiousness: 0.778441636, extraversion: 0.422372, agreeableness: 0.653384318, emotional_range: 0.1622277273, enjoyment_score: 0.161, big_five_score: 2.83, dissatisfaction_score: 0.350)
    bad_bad_response_2 = Response.create(company_id: company.id, category: 2, domain: 0, disgust: 0.038420909, fear: 0.052893318, joy: 0.286413909, sadness: 0.558661545, anger: 0.105502864, openness: 0.193824, conscientiousness: 0.478441636, extraversion: 0.422372, agreeableness: 0.653384318, emotional_range: 0.242277273, enjoyment_score: 0.188, big_five_score: 3.00, dissatisfaction_score: 0.550)

    email = {
      user_id: company.id,
      domain: 0,
      question: "Hello, I want to know about your store, give me some information why don't you.",
      response: "I don't like that you are emailing us...at all. Don't email us again about this topic. "
    }

    post "/api/v1/category", :params => email

    expect(response).to be_success

    scores = JSON.parse(response.body)

    expect(scores["overall_score"]["enjoyment"]).to eq("Overall tone is unprofessional.")
    expect(scores["overall_score"]["brand"]).to eq("Brand suffered from interaction.")
  end

  xit "responds with an appropriate category for a professionally written email" do
    company = create(:company)
    good_good_response_1 = Response.create!(company_id: company.id, category: 0, domain: 0, disgust: 0.020028, fear: 0.02473, joy: 0.074382, sadness: 0.1019232, anger: 0.059976, openness: 0.119831, conscientiousness: 0.99957, extraversion: 0.607163, agreeableness: 0.92923, emotional_range: 0.947887, enjoyment_score: 0.814108, big_five_score: 3.597, dissatisfaction_score: 1.198)
    good_good_response_2 = Response.create(company_id: company.id, category: 0, domain: 0, disgust: 0.035028, fear: 0.007473, joy: 0.664382, sadness: 0.09232, anger: 0.050176, openness: 0.290831, conscientiousness: 0.99857, extraversion: 0.938163, agreeableness: 0.99123, emotional_range: 0.878987, enjoyment_score: 1.0275, big_five_score: 3.285, dissatisfaction_score: 0.858)
    good_good_response_3 = Response.create(company_id: company.id, category: 1, domain: 0, disgust: 0.035028, fear: 0.007473, joy: 0.664382, sadness: 0.09232, anger: 0.050176, openness: 0.290831, conscientiousness: 0.99857, extraversion: 0.938163, agreeableness: 0.99123, emotional_range: 0.878987, enjoyment_score: 0.6275, big_five_score: 3.5085, dissatisfaction_score: 0.678)
    good_good_response_3 = Response.create(company_id: company.id, category: 1, domain: 0, disgust: 0.035028, fear: 0.007473, joy: 0.664382, sadness: 0.09232, anger: 0.050176, openness: 0.290831, conscientiousness: 0.99857, extraversion: 0.938163, agreeableness: 0.99123, emotional_range: 0.878987, enjoyment_score: 0.39275, big_five_score: 2.2085, dissatisfaction_score: 0.719)
    bad_bad_response_1 = Response.create(company_id: company.id, category: 2, domain: 0, disgust: 0.058420909, fear: 0.042893318, joy: 0.216413909, sadness: 0.258661545, anger: 0.085502864, openness: 0.273824, conscientiousness: 0.778441636, extraversion: 0.422372, agreeableness: 0.653384318, emotional_range: 0.1622277273, enjoyment_score: 0.161, big_five_score: 2.83, dissatisfaction_score: 0.350)
    bad_bad_response_2 = Response.create(company_id: company.id, category: 2, domain: 0, disgust: 0.038420909, fear: 0.052893318, joy: 0.286413909, sadness: 0.558661545, anger: 0.105502864, openness: 0.193824, conscientiousness: 0.478441636, extraversion: 0.422372, agreeableness: 0.653384318, emotional_range: 0.242277273, enjoyment_score: 0.188, big_five_score: 3.00, dissatisfaction_score: 0.550)

    email = {
      user_id: company.id,
      domain: 0,
      question: "Hello, I want to know about your store, give me some information why don't you.",
      response: "Hi Customer one, Great news, we have both of those boards available right now and we've set them aside for you. Let one of our staff know you email us about these boards, they will know where to take you. Looking forward to seeing you tomorrow!"
    }

    post "/api/v1/category", :params => email

    expect(response).to be_success

    scores = JSON.parse(response.body)

    expect(scores["overall_score"]["enjoyment"]).to eq("Overall tone of this email is positive and agreeable.")
    expect(scores["overall_score"]["brand"]).to eq("Great brand representation.")
  end

  it "responds with an appropriate category for an average email" do
    company = create(:company)
    good_good_response_1 = Response.create!(company_id: company.id, category: 0, domain: 0, disgust: 0.020028, fear: 0.02473, joy: 0.074382, sadness: 0.1019232, anger: 0.059976, openness: 0.119831, conscientiousness: 0.99957, extraversion: 0.607163, agreeableness: 0.92923, emotional_range: 0.947887, enjoyment_score: 0.814108, big_five_score: 3.597, dissatisfaction_score: 1.198)
    good_good_response_2 = Response.create(company_id: company.id, category: 0, domain: 0, disgust: 0.035028, fear: 0.007473, joy: 0.664382, sadness: 0.09232, anger: 0.050176, openness: 0.290831, conscientiousness: 0.99857, extraversion: 0.938163, agreeableness: 0.99123, emotional_range: 0.878987, enjoyment_score: 1.0275, big_five_score: 3.285, dissatisfaction_score: 0.858)
    good_good_response_3 = Response.create(company_id: company.id, category: 1, domain: 0, disgust: 0.035028, fear: 0.007473, joy: 0.664382, sadness: 0.09232, anger: 0.050176, openness: 0.290831, conscientiousness: 0.99857, extraversion: 0.938163, agreeableness: 0.99123, emotional_range: 0.878987, enjoyment_score: 0.6275, big_five_score: 3.5085, dissatisfaction_score: 0.678)
    good_good_response_3 = Response.create(company_id: company.id, category: 1, domain: 0, disgust: 0.035028, fear: 0.007473, joy: 0.664382, sadness: 0.09232, anger: 0.050176, openness: 0.290831, conscientiousness: 0.99857, extraversion: 0.938163, agreeableness: 0.99123, emotional_range: 0.878987, enjoyment_score: 0.39275, big_five_score: 2.2085, dissatisfaction_score: 0.719)
    bad_bad_response_1 = Response.create(company_id: company.id, category: 2, domain: 0, disgust: 0.058420909, fear: 0.042893318, joy: 0.216413909, sadness: 0.258661545, anger: 0.085502864, openness: 0.273824, conscientiousness: 0.778441636, extraversion: 0.422372, agreeableness: 0.653384318, emotional_range: 0.1622277273, enjoyment_score: 0.161, big_five_score: 2.83, dissatisfaction_score: 0.350)
    bad_bad_response_2 = Response.create(company_id: company.id, category: 2, domain: 0, disgust: 0.038420909, fear: 0.052893318, joy: 0.286413909, sadness: 0.558661545, anger: 0.105502864, openness: 0.193824, conscientiousness: 0.478441636, extraversion: 0.422372, agreeableness: 0.653384318, emotional_range: 0.242277273, enjoyment_score: 0.188, big_five_score: 3.00, dissatisfaction_score: 0.550)

    email = {
      user_id: company.id,
      domain: 0,
      question: "Hello, I want to know about your store, give me some information why don't you.",
      response: "Hi Customer one, I am pleased to say we have those two boards available, but we cannot hold them for you. Because of how low our stock is right now, everything is on a first come first serve basis. I'm sorry we cannot guarantee the items for you and your wife. Feel free to call tomorrow morning before the drive to ask if they are available."
    }

    post "/api/v1/category", :params => email

    expect(response).to be_success

    scores = JSON.parse(response.body)

    expect(scores["overall_score"]["enjoyment"]).to eq("Overall tone uncertain. Recommend re-write.")
    expect(scores["overall_score"]["brand"]).to eq("Overall positive brand representation.")
    expect(scores["overall_score"]["category"]).to eq("moderate")
  end
end
