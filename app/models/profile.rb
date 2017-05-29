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



  def facebook_details
    api_caller =  Koala::Facebook::API.new(self.token)
    event_response =  api_caller.get_connections("me", "events", {limit: 1})
    friends_response = api_caller.get_connections("me", "friends", api_version: "v2.0")
    {
      followers: [friends_response["summary"]["total_count"], "friends"],
      detail: "Next Event: #{self.name} is #{event_response["data"][0]["rsvp_status"]} :",
      link: [event_response["data"][0]["description"], "https://www/facebook.com/events/#{event_response["data"][0]["id"]}"]
    }
  end

  def twitter_details
    response = TwitterAPI.users(self.nickname).first
    {
      followers: [response.followers_count, "followers"]
      details:
    }
  end

  def youtube_details
    if (Time.now.utc > self.expires_at - 60)
      refresh_google_token
    end
    uri = "https://www.googleapis.com/youtube/v3/channels?part=statistics&id=#{self.uid}"
    headers = {
      'Authorization' => 'Bearer ' + self.token
    }
    api_response = HTTParty.get(uri, headers: headers)
    if api_response.code == 200
      stats = api_response.parsed_response["items"][0]["statistics"]
      return {
        followers: [stats["subscriberCount"], "subscribers"],
        detail: "#{stats["videoCount"]} videos and #{stats["viewCount"]} views"
      }
    else
      return {
        followers: ['?', "subscribers"],
        details: ""
      }
    end
  end

  def google_details
    if (Time.now.utc > self.expires_at - 60)
      refresh_google_token
    end
    uri = "https://www.googleapis.com/plus/v1/people/me?fields=tagline%2CcircledByCount"
    headers = {
      'Authorization' => 'Bearer ' + self.token
    }
    api_response = HTTParty.get(uri, headers: headers)
    if api_response.code == 200
      return {
        followers: [api_response.parsed_response["circledByCount"], "followers"],
        detail: api_response.parsed_response["tagline"]
      }
    else
      return {
        followers: ['?', "followers"],
        details: ""
      }
    end
  end

  def blog_posts(limit = false)
    BlogPost.get_posts(self, limit)
  end


end
