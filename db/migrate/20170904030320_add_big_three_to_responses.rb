class AddBigThreeToResponses < ActiveRecord::Migration[5.1]
  def change
    add_column :responses, :big_five_score, :float
  end
end
