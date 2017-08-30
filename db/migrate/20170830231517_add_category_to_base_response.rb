class AddCategoryToBaseResponse < ActiveRecord::Migration[5.1]
  def change
    add_column :base_responses, :category, :integer
  end
end
