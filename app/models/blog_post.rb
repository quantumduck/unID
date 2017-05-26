class BlogPost

  attr_reader :profile_id, :text, :url, :picture, :time

  def initialize(data)
    @profile_id = data[:profile_id]
    @text = data[:text]
    @url = data[:url]
    @picture = data[:picture]
    @time = data[:time]
  end

  def profile
    Profile.find(self.profile_id)
  end

  def self.get_posts(profile, limit = false)

  end

  def self.get_twitter(profile)
    posts =
    TwitterAPI.user_timeline(profile.nickname).map do |post|
      new(
        profile: profile.id,
        text: post.text,
        url: post.uri.to_s,
        picture: profile.image,
        time: post.created_at
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
        image = profile.image
      end
      new(
        profile: profile.id,
        text: post['summary'],
        url: post['post_url'],
        picture: image,
        time: post['date'].to_time
      )
    end
    posts
  end

  def self.get_youtube(profile)
    # First refresh the token
    if (Time.now.utc > profile.expires_at - 60)
      profile = profile.refresh_google_token
      unless profile
        return []
      end
    end
    uploads_id = profile.uid
    # Get the upload playlist id:
    uploads_id[1] = 'U'
    uploads_id = 'UULtREJY21xRfCuEKvdki1Kw'
    headers = {
      'Authorization' => 'Bearer ' + profile.token
    }
    uri = 'https://www.googleapis.com/youtube/v3/playlistItems?part=id%2Csnippet&playlistId=' + uploads_id
    response = HTTParty.get(uri, headers: headers)
    if response.parsed_response['items']
      uploads =
      response.parsed_response['items'].map do |vid|
        new(
          provider: 'youtube',
          text: vid['snippet']['title'],
          url: 'https://www.youtube.com/watch?v=' + vid['snippet']['resourceId']['videoId'],
          picture: vid['snippet']['thumbnails']['default']['url'],
          time: vid['snippet']['publishedAt'].to_time
        )
      end
      return uploads
    else
      return []
    end
  end


end
