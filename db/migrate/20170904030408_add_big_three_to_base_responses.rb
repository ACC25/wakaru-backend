class AddBigThreeToBaseResponses < ActiveRecord::Migration[5.1]
  def change
    add_column :base_responses, :big_five_score, :float
  end
end
