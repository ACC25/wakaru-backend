require 'rails_helper'

describe "POST /api/v1/category?" do
  it "responds with the category of the email" do
    email = {
      question: "Hello, I want to know about your store, give me some information why don't you.",
      response: "Hello there customer one! We are a company of many products. We have products that span the world, from toys to spaceships. Are you interested in a specific type of product? I'd be happy to go over our product line with you if you want. Have a nice day."
    }

    post "/api/v1/category", :params => email

    
  end
end
