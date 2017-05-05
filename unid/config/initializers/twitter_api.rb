# Configure twitter gem with authentication credentials

client = Twitter::REST::Client.new do |config|
  config.consumer_key    = "o6WxNKLcDbsfooct2EEhcLKJj"
  config.consumer_secret = "gjmZSCWTehlgj2VR0zdgpnknol9ufA34XilvGFrRjTFpLQRwhJ"
end
