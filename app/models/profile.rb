class Profile < ApplicationRecord
  mount_uploader :image_other, ProfilepicUploader
  belongs_to :user

  scope :shared, ->(profile_params) {
    where(uid: profile_params[:uid],  provider: profile_params[:provider])
  }

  scope :same_user, ->(user) { where(user_id: user.id) }

  validates :url, :name, presence: true
  # validate :disallow_login_on_shared_profiles
  before_save :set_position

  def set_position
    unless self.position
      self.position = self.user.profiles.length
    end
  end

  def short_description
    maxlength = 30
    unless description
      return 'My ' + provider.capitalize + ' profile'
    end
    output = description.split('\n').first
    unless output
      return 'My ' + provider.capitalize + ' profile'
    end
    if output.length > maxlength
      output = output[0, maxlength - 3] + '...'
    elsif output.length == 0
      output = provider.capitalize + ' profile'
    end
    output
  end

  def disallow_login_on_shared_profiles
    if shared(uid: uid, provider: provider).size > 1
      if allow_login
        errors.add(:allow_login, "must be false for shared profiles.")
      end
    end
  end

  def refresh_google_token
    uri = 'https://www.googleapis.com/oauth2/v4/token'
    body = "client_id=#{CGI.escape(ENV['google_client_id'])}&" + \
           "client_secret=#{CGI.escape(ENV['google_client_id_secret'])}&" + \
           "refresh_token=#{CGI.escape(refresh_token)}&" + \
           "grant_type=refresh_token"
    response = HTTParty.post(uri, body: body)
    if response.parsed_response['access_token']
      self.token = response.parsed_response['access_token']
      self.expires_at = Time.now + response.parsed_response['expires_in']
      self.save
    else
      return false
    end
    return self
  end

  # def facebook_token
  #   facebook_profile = profiles.where(provider: 'facebook').first
  #   if facebook_profile
  #     facebook_profile.token
  #   else
  #     nil
  #   end
  # end
  def facebook
    if provider == 'facebook'
      @facebook = Koala::Facebook::API.new(self.token )
    else
      @facebook = nil
    end
  end

  # def facebook_posts
  #   if facebook
  #   facebook.get_connections("me","posts", {
  #     limit: 1
  #     }).raw_response["data"]
  #   end
  # end
  def facebook_events
    facebook.get_connections("me","events", {
      limit: 1,
      # fields = ["rsvp_status", "description", ]
      }).raw_response["data"]
  end
  def facebook_friends_count
    facebook.get_connections("me","friends",api_version:"v2.0").raw_response["summary"]["total_count"]
  end
end
