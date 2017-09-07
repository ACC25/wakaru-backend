class AddDisatisfactionScoreToResponses < ActiveRecord::Migration[5.1]
  def change
    add_column :responses, :dissatisfaction_score, :float
  end
end
