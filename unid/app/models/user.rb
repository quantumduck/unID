class User < ApplicationRecord

  has_many :profiles

  validates :username, :email, uniqueness: true
  validates :username, :email, presence: true


end
