Koala.configure do |config|
#   config.access_token = ENV["facebook_access_token"]
#   config.app_access_token = ENV["facebook_app_access_token"]
   config.app_id = ENV["facebook_app_id"]
   config.app_secret = ENV["facebook_app_secret"]
#   # See Koala::Configuration for more options, including details on how to send requests through
#   # your own proxy servers.
end
