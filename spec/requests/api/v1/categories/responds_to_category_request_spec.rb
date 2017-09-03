require 'rails_helper'

describe "POST /api/v1/category?" do
  it "responds with the category of the email" do
    company = create(:company)
    good_good_response_1 = create(:response, company_id: company.id, category: 0, domain: 0, disgust: 0.030028, fear: 0.009473, joy: 0.084382, sadness: 0.019232, anger: 0.029976, openness: 0.475831, conscientiousness: 0.98957, extraversion: 0.408163, agreeableness: 0.97923, emotional_range: 0.987887 )
    good_good_response_2 = create(:response, company_id: company.id, category: 0, domain: 0, disgust: 0.025028, fear: 0.007473, joy: 0.074382, sadness: 0.009232, anger: 0.020176, openness: 0.395831, conscientiousness: 0.80157, extraversion: 0.808163, agreeableness: 0.91923, emotional_range: 0.987887 )
    bad_bad_response_1 = create(:response, company_id: company.id, category: 2, domain: 0, disgust: 0.058420909, fear: 0.042893318, joy: 0.216413909, sadness: 0.258661545, anger: 0.085502864, openness: 0.273824, conscientiousness: 0.778441636, extraversion: 0.422372, agreeableness: 0.653384318, emotional_range: 0.842277273 )
    bad_bad_response_2 = create(:response, company_id: company.id, category: 2, domain: 0, disgust: 0.038420909, fear: 0.052893318, joy: 0.286413909, sadness: 0.558661545, anger: 0.105502864, openness: 0.193824, conscientiousness: 0.478441636, extraversion: 0.422372, agreeableness: 0.653384318, emotional_range: 0.842277273 )

    email = {
      user_id: company.id,
      domain: 0,
      question: "Hello, I want to know about your store, give me some information why don't you.",
      response: "Hello there customer one! We are a company of many products. We have products that span the world, from toys to spaceships. Are you interested in a specific type of product? I'd be happy to go over our product line with you if you want. Have a nice day."
    }

    post "/api/v1/category", :params => email


  end
end
