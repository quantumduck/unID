
Instagram.configure do |config|
  config.client_id = ENV['instagram_client_id']
  config.client_secret = ENV['instagram_client_secret']
  config.access_token = ENV['instagram_access_token']
  # For secured endpoints only
  #config.client_ips = '<Comma separated list of IPs>'
end
