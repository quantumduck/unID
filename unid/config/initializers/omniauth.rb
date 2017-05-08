Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV["twitter_consumer_key"], ENV["twitter_consumer_secret"]
  {
    :authorize_params => {
      :force_login => 'true',
      :use_authorize => 'true'
    }
  }
end
