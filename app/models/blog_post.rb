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
    when 'facebook'
      get_facebook(profile, limit)
    when 'instagram'
      get_instagram(profile, limit)
    when 'google'
      get_googleplus(profile, limit)
    else
      []
    end
    posts
  end

  def self.get_twitter(profile, limit = false)
    posts =
    TwitterAPI.user_timeline(profile.nickname).map do |post|
      if post.media.any?
        photos = []
        post.media.each { |m| photos.push(m) if m.class == Twitter::Media::Photo }
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

  def self.get_facebook(profile, limit = false)
    if limit
      options = {limit: limit}
    else
      options = {}
    end
    options[:fields] = ["picture", "created_time", "message", "type", "story", "name", "permalink_url"]
    posts = Koala::Facebook::API.new(profile.token).get_connections("me", "posts", options).raw_response
    posts['data'].map do |post|
      if post['message']
        text = post['message']
      elsif post['name']
        text = post['name']
      elsif post['story']
        text = post['story']
      else
        text = ""
      end
      if post['picture']
        picture = post['picture']
      else
        picture = profile.image
      end
       new(
       profile_id: profile.id,
       text: text,
       url: post["permalink_url"],
       picture: picture,
       time: post['created_time'].to_time
       )

    end
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
  def self.get_instagram(profile, limit)
    uri = "https://api.instagram.com/v1/users/self/media/recent/?access_token="
    uri += profile.token
    if limit && limit >= 1
      uri += "&count=#{limit}"
    end
    response = HTTParty.get(uri)
    posts =
    response['data'].map do |post|
      if post['caption']
        text = post['caption']['text']
      else
        text = ""
      end
      new(
      profile_id: profile.id,
      text: text,
      url: post['link'],
      picture: post['images']['thumbnail']['url'],
      time: Time.at(post['created_time'].to_i).utc

      )
    end
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

  def self.get_googleplus(profile, limit = false)
    if (Time.now.utc > profile.expires_at - 60)
      profile = profile.refresh_google_token
      unless profile
        return []
      end
    end
    headers = {
      'Authorization' => 'Bearer ' + profile.token
    }
    uri = "https://www.googleapis.com/plus/v1/people/me/activities/public"
    if limit && limit >=1 && limit <= 100
      uri += "?maxResults=#{limit}"
    end
    response = HTTParty.get(uri, headers: headers)
    if response.parsed_response['items']
      activities = response.parsed_response['items'].map do |post|
        if post['object']['attachments']
          if post['object']['attachments'][0]['objectType'] == 'photo'
            image = post['object']['attachments'][0]['image']['url']
          else
            image = profile.image
          end
        else
          image = profile.image
        end
        new(
          profile_id: profile.id,
          text: post['title'],
          url: post['url'],
          picture: image,
          time: post['published'].to_time
        )
      end
      return activities
    else
      return []
    end
  end

end
