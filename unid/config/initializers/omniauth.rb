Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :twitter, ENV["twitter_consumer_key"], ENV["twitter_consumer_secret"]
  {
    :authorize_params => {
      :force_login => 'true',
      :use_authorize => 'true'
    }
  }
  provider :google_oauth2, ENV["google_client_id"], ENV["google_client_id_secret"]
  {
    scope: 'email,profile,https://www.googleapis.com/auth/youtube.readonly',
    prompt: "select_account",
    image_size: 50
  }
end


# https://www.googleapis.com/youtube/v3/channels?part=id&mine=true
