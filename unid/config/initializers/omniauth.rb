Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :tumblr, ENV['TUMBLR_KEY'], ENV['TUMBLR_SECRET']
  provider :twitter, ENV["twitter_consumer_key"], ENV["twitter_consumer_secret"]
  {
    :authorize_params => {
      :force_login => 'true',
      :use_authorize => 'true'
    }
  }
  provider :facebook, ENV["facebook_app_id"], ENV["facebook_app_secret"]

  provider :linkedin, ENV['linkedin_client_id'], ENV['linkedin_secret'], secure_image_url: true

  provider :github, ENV['github_client_id'], ENV['github_client_secret']

  provider :twitch, ENV['TWITCH_CLIENT_ID'],  ENV['TWITCH_CLIENT_SECRET'], scope: "user_read,channel_read,channel_editor"

end


# https://www.googleapis.com/youtube/v3/channels?part=id&mine=true
