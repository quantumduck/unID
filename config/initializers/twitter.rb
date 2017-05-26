Figaro.require_keys("twitter_consumer_key", "twitter_consumer_secret", "twitter_access_token", "twitter_access_token_secret")
#
TwitterAPI = Twitter::REST::Client.new do |config|
    #Make secret values go here:
    config.consumer_key        = ENV["twitter_consumer_key"]
    config.consumer_secret     = ENV["twitter_consumer_secret"]
    config.access_token        = ENV["twitter_access_token"]
    config.access_token_secret = ENV["twitter_access_token_secret"]
  end
