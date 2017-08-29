class CreateUtterances < ActiveRecord::Migration[5.1]
  def change
    create_table :utterances do |t|
      t.string :question_tone_name
      t.float :question_tone
      t.string :question_tone_name_two
      t.float :question_tone_two
      t.string :response_tone_name
      t.float :response_tone
      t.string :response_tone_name_two
      t.float :response_tone_two
    end
  end
end
