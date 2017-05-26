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
    posts =
    case profile.provider
    when 'twitter'
      get_twitter(profile, limit)
    when 'tumblr'
      get_tumblr(profile, limit)
    when 'youtube'
      get_youtube(profile, limit)
    # when 'facebook'
    #   get_facebook(profile, limit)
    else
      []
    end
    posts
  end

  def self.get_twitter(profile, limit = false)
    posts =
    TwitterAPI.user_timeline(profile.nickname).map do |post|
      if post.media.any?
        photos = post.media.delete_if { |m| m.class != Twitter::Media::Photo }
        if photos.length > 0
          image = photos[0].media_uri.to_s
        else
          image = profile.image
        end
      else
        image = profile.image
      end
      new(
        profile_id: profile.id,
        text: post.text,
        url: post.uri.to_s,
        picture: image,
        time: post.created_at
      )
    end
    if limit && posts.length > limit
      posts = posts[0, limit]
    end
    posts
  end

  # def self.get_facebook(profile, limit)
  #   acebook.get_connections("me", "posts")
  # end

  def self.get_tumblr(profile, limit = false)
    uri = "https://api.tumblr.com/v2/blog/" + \
          "#{profile.uid}" + ".tumblr.com"\
          "/posts?api_key=" + \
          "#{ENV['TUMBLR_KEY']}"
    if limit && limit >= 1 && limit <= 20
      uri += "&limit=#{limit}"
    end
    response = HTTParty.get(uri)
    posts =
    response['response']['posts'].map do |post|
      case post['type']
      when 'photo'
        image = post['photos'][0]['original_size']['url']
      else
        image = profile.image
      end
      new(
        profile_id: profile.id,
        text: post['summary'],
        url: post['post_url'],
        picture: image,
        time: post['date'].to_time
      )
    end
    posts
  end

  def self.get_youtube(profile, limit = false)
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
    # uploads_id = 'UULtREJY21xRfCuEKvdki1Kw'
    headers = {
      'Authorization' => 'Bearer ' + profile.token
    }
    uri = 'https://www.googleapis.com/youtube/v3/playlistItems?part=id%2Csnippet&playlistId=' + uploads_id
    if limit && limit >= 1 && limit <= 50
      uri += "&maxResults=#{limit}"
    end
    response = HTTParty.get(uri, headers: headers)
    if response.parsed_response['items']
      uploads =
      response.parsed_response['items'].map do |vid|
        new(
          profile_id: profile.id,
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
