# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170911231128) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "base_responses", force: :cascade do |t|
    t.integer "domain", default: 0
    t.string "response_text"
    t.string "question_text"
    t.float "disgust"
    t.float "fear"
    t.float "joy"
    t.float "sadness"
    t.float "anger"
    t.float "analytical"
    t.float "confident"
    t.float "tentative"
    t.float "openness"
    t.float "conscientiousness"
    t.float "extraversion"
    t.float "agreeableness"
    t.float "emotional_range"
    t.integer "category"
    t.float "enjoyment_score"
    t.float "big_five_score"
    t.float "dissatisfaction_score"
  end

  create_table "base_utterances", force: :cascade do |t|
    t.string "question_tone_name"
    t.float "question_tone"
    t.string "question_tone_name_two"
    t.float "question_tone_two"
    t.string "response_tone_name"
    t.float "response_tone"
    t.string "response_tone_name_two"
    t.float "response_tone_two"
    t.bigint "base_response_id"
    t.index ["base_response_id"], name: "index_base_utterances_on_base_response_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.string "password_digest"
    t.string "auth_token"
  end

  create_table "responses", force: :cascade do |t|
    t.integer "domain", default: 0
    t.integer "category"
    t.bigint "company_id"
    t.string "response_text"
    t.string "question_text"
    t.float "disgust"
    t.float "fear"
    t.float "joy"
    t.float "sadness"
    t.float "anger"
    t.float "analytical"
    t.float "confident"
    t.float "tentative"
    t.float "openness"
    t.float "conscientiousness"
    t.float "extraversion"
    t.float "agreeableness"
    t.float "emotional_range"
    t.float "enjoyment_score"
    t.float "big_five_score"
    t.float "dissatisfaction_score"
    t.index ["company_id"], name: "index_responses_on_company_id"
  end

  add_foreign_key "base_utterances", "base_responses"
  add_foreign_key "responses", "companies"
end
