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



  def facebook_api_caller
      @api_caller =  Koala::Facebook::API.new(self.token)
    end

      def facebook_friends

      # event_response =  api_caller.get_connections("me", "events", {limit: 1})
      friends_response = facebook_api_caller.get_connections("me", "friends", api_version: "v2.0").raw_response["summary"]["total_count"]
    end
    def facebook_posts
      posts_response = facebook_api_caller.get_connections("me","posts", {
        limit: 1
        }).raw_response["data"]
    end
    def facebook_events
    events_response = facebook_api_caller.get_connections("me","events", {
        limit: 1
        }).raw_response["data"]
    end


  def twitter_details
    response = TwitterAPI.users(self.nickname).first
    {
      followers: [response.followers_count, "followers"],
      details: "#{response.statuses_count} tweets"
    }
  end

  def tumblr_details
    uri = "https://api.tumblr.com/v2/blog/" + \
          "#{self.uid}" + ".tumblr.com"\
          "/info?api_key=" + \
          "#{ENV['TUMBLR_KEY']}"
    api_response = HTTParty.get(uri)
    if api_response.code == 200
      return {
        followers: [api_response.parsed_response["response"]["blog"]["likes"], "likes"],
        detail: "#{api_response.parsed_response["response"]["blog"]["total_posts"]} posts"
      }
    else
      return {
        followers: ['?', "likes"],
        detail: ""
      }
    end
  end

  def instagram_details
    uri = "https://api.instagram.com/v1/users/self/?access_token=#{self.token}"
    api_response = HTTParty.get(uri)
    if api_response.code == 200
      return {
        followers: [api_response.parsed_response['counts']['followed_by'], "followers"],
        detail: "#{api_response.parsed_response['counts']['media']} pictures and videos"
      }
    else
      return {
        followers: ['?', "likes"],
        detail: ""
      }
    end
  end

  def linkedin_details
    uri = "https://api.linkedin.com/v1/people/~:(id,num-connections,positions)?format=json"
    headers = {"Authorization" => "Bearer #{p.token}"}
    api_response = HTTParty.get(uri, headers: headers)
    if api_response.code == 200
      if api_response["positions"]["_total"] >= 1
        position = "Current position: #{api_response.parsed_response["positions"]["value"][0]["company"]["name"]}"
      else
        position = "No current position"
      end
      return {
        followers: [api_response.parsed_response["numConnections"], "connections"],
        details: position
      }
    else
      return {
        followers: ['?', "likes"],
        detail: ""
      }
    end
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
