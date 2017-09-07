class AddDisatisfactionScoreToBaseResponses < ActiveRecord::Migration[5.1]
  def change
    add_column :base_responses, :dissatisfaction_score, :float
  end
end
