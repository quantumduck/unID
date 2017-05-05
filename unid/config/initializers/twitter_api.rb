# Configure twitter gem with authentication credentials

client = Twitter::REST::Client.new do |config|
  config.consumer_key    = ""
  config.consumer_secret = ""
end
