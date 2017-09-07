class AddEnjoymentScoreToBaseResponses < ActiveRecord::Migration[5.1]
  def change
    add_column :base_responses, :enjoyment_score, :float
  end
end
