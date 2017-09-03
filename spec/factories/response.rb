FactoryGirl.define do
  factory :response do
    association :company, factory: :company
    domain 0
    category 0
    response_text "Sample"
    question_text "Sample"
    disgust 0
    fear 0
    joy 0
    sadness 0
    anger 0
    analytical 0
    confident 0
    tentative 0
    openness 0
    conscientiousness 0
    extraversion 0
    agreeableness 0
    emotional_range 0
  end
end
