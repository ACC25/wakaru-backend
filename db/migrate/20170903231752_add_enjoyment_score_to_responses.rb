class AddEnjoymentScoreToResponses < ActiveRecord::Migration[5.1]
  def change
    add_column :responses, :enjoyment_score, :float
  end
end
