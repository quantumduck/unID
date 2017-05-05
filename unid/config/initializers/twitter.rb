Twitter.require_keys("consumer_key", "consumer_secret", "access_token", "access_token_secret")

CLIENT = Twitter::REST::Client.new do |config|
    #Make secret values go here:
    config.consumer_key        = ENV["consumer_key"]
    config.consumer_secret     = ENV["consumer_secret"]
    config.access_token        = ENV["access_token"]
    config.access_token_secret = ENV["access_token_secret"]
  end
