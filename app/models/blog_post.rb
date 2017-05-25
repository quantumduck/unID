class BlogPost

  attr_reader :provider, :text, :url, :picture

  def initialize(data)
    @provider = data[:provider]
    @text = data[:text]
    @url = data[:url]
    @picture = data[:picture]
  end

  def self.get_twitter(profile)
    posts =
    TwitterAPI.user_timeline(profile.nickname).map do |post|
      new(
        provider: 'twitter',
        text: post.text,
        url: "https://twitter.com/#{profile.nickname}/status/#{post.id}"
      )
    end
    posts
  end

  def self.get_tumblr(profile)
    response = HTTParty.get(
      "https://api.tumblr.com/v2/blog/" + \
      "#{profile.uid}" + ".tumblr.com"\
      "/posts?api_key=" + \
      "#{ENV['TUMBLR_KEY']}"
    )
    posts =
    response['response']['posts'].map do |post|
      case post['type']
      when 'photo'
        image = post['photos'][0]['original_size']['url']
      else
        image = nil
      end
      new(
        provider: 'tumblr',
        text: post['summary'],
        url: post['post_url'],
        picture: image
      )
    end
    posts
  end

  def self.get_youtube(profile)
    # First refresh the token
    refresh_google_token(profile)

    uploads_id = profile.uid
    # Get the upload playlist id:
    uploads_id[1] = 'U'
    headers = {
      'Authorization' => 'Bearer ' + profile.token
    }
    uri = 'https://www.googleapis.com/youtube/v3/playlistItems?part=id%2Csnippet&playlistId=' + uploads_id
    response = HTTParty.get(uri, headers: headers)
    uploads =
    response.parsed_response['items'].map do |vid|
      new(
        provider: 'youtube',
        text: vid['snippet']['title'],
        url: 'https://www.youtube.com/watch?v=' + vid['snippet']['resourceId']['videoId'],
        picture: vid['snippet']['thumbnails']['default']['url']
      )
    end
    uploads
  end


  def refresh_google_token(profile)
    uri = 'https://www.googleapis.com/oauth2/v4/token'
    body = "client_id=#{CGI.escape(ENV['google_client_id'])}&" + \
           "client_secret=#{CGI.escape(ENV['google_client_id_secret'])}&" + \
           "refresh_token=#{CGI.escape(profile.refresh_token)}&" + \
           "grant_type=refresh_token"
    response = HTTParty.post(uri, body: body)
    if response.parsed_response['access_token']
      profile.token = response.parsed_response['access_token']
      profile.expires_at = Time.now + response.parsed_response['expires_in']
      profile.save
    end
  end

  def get_facebook_long_lived_token(profile)
    uri = 'https://graph.facebook.com/v2.3/oath/access_token?grant_type=fb_exchange_token&' + \
          "client_id=#{ENV['facebook_app_id']}&" + \
          "client_secret=#{ENV['facebook_app_secret']}&" + \
          "fb_exchange_token=#{profile.token}"
    headers = {'Accept' => 'application/json, */*'}
    response = HTTParty.get(uri, headers: headers)
  end

end
