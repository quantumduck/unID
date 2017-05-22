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

end
