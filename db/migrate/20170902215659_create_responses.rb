class CreateResponses < ActiveRecord::Migration[5.1]
  def change
    create_table :responses do |t|
      t.integer :domain, default: 0
      t.integer :category
      t.references :company, foreign_key: true
      t.string :response_text
      t.string :question_text
      t.float :disgust
      t.float :fear
      t.float :joy
      t.float :sadness
      t.float :anger
      t.float :analytical
      t.float :confident
      t.float :tentative
      t.float :openness
      t.float :conscientiousness
      t.float :extraversion
      t.float :agreeableness
      t.float :emotional_range
    end
  end
end
