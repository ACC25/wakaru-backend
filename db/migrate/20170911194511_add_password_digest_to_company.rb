class AddPasswordDigestToCompany < ActiveRecord::Migration[5.1]
  def change
    add_column :companies, :password_digest, :string
  end
end
