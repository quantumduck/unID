class BlogPost

  attr_reader :provider, :text, :url

  def initialize(data)
    @provider = data[:provider]
    @text = data[:text]
    @url = data[:url]
    @picture = data[:image]
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
      "#{profile.uid}" + \
      "/posts?api_key=" + \
      "#{ENV['TUMBLR_KEY']}"
    )
  end

end
