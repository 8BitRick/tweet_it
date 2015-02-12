module TwitterClient
  def client
    @client ||= Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_KEY']
      config.consumer_secret     = ENV['TWITTER_SECRET']
      config.access_token        = session['token']
      config.access_token_secret = session['secret']
    end
  end

  def save_tweets(raw_tweets)
    raw_tweets.each do |s|
      h = Hash(s)
      Tweet.where(user: h[:user][:screen_name],
                  id_str: h[:id_str],
                  tx: h[:text],
                  raw: h.to_json).first_or_create
    end
  end
end
