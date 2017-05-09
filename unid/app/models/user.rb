class User < ApplicationRecord
  has_secure_password
  has_many :networks

  validates :username, :email, uniqueness: true
  validates :username, :email, presence: true


end
