class User < ApplicationRecord
  mount_uploader :avatar, AvatarUploader
  has_secure_password
  has_many :profiles

  validates :username, :email, uniqueness: true
  validates :username, :email, presence: true

  validate :username_url_safe
  validate :email_format

  def username_url_safe
    if CGI.escape(username) != username
      errors.add(:username, "must only contain URL-safe characters.")
    end
  end

  def email_format
    unless email =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      errors.add(:email, "is not an email")
    end
  end

  def facebook_token
    facebook_profile = profiles.where(provider: 'facebook').first
    if facebook_profile
      facebook_profile.token
    else
      nil
    end
  end
  def facebook
      @graph = Koala::Facebook::API.new(facebook_token)
  end
end
