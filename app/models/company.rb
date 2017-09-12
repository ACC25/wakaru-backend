class Company < ApplicationRecord
  has_secure_password
  has_many :responses

  validates :name, presence: true, uniqueness: true
end
