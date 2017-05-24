class User < ApplicationRecord
  require 'koala'
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
      @facebook = Koala::Facebook::API.new(facebook_token)
  end
  def facebook_posts
    facebook.get_connections("me","posts", {
      limit: 1
      })
  end
  def facebook_events
    facebook.get_connections("me","events")
  end

  def self.find_unique(query_name)
    counter = 1

    if User.find_by(username: query_name)
      while true

        if User.find_by(username: query_name + counter.to_s)
          counter += 1
        else
          return query_name + counter.to_s
        end


      end

    end
    return query_name
  end

end
