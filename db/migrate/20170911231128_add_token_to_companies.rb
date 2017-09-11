class AddTokenToCompanies < ActiveRecord::Migration[5.1]
  def change
    add_column :companies, :auth_token, :string
  end
end
