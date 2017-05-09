class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable,
         omniauth_providers: [:twitter, :facebook, :google]

  has_many :profiles

  validates :username, :email, uniqueness: true
  validates :username, :email, presence: true


end
