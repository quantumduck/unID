Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV["twitter_consumer_key"], ENV["twitter_consumer_secret"]
  {
    :authorize_params => {
      :force_login => 'true',
      :use_authorize => 'true'
    }
  }
  provider :google_oauth2, ENV["google_client_id"], ENV["google_client_id_secret"]

end
