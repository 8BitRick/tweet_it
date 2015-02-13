module TwitterClient
  def client
    @client ||= Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_KEY']
      config.consumer_secret     = ENV['TWITTER_SECRET']
      config.access_token        = session['token']
      config.access_token_secret = session['secret']
    end
  end

  def update_tweet_cache(user)
    inf = Influencer.find_by(handle: user)
    if(inf.nil?)
      return false
    end

    # Check if need to update tweet cache for this influencer
    if(inf.last_tweet_request.nil? || (inf.last_tweet_request > 10.minutes.ago))
      raw_tweets = client.user_timeline(user)
      save_tweets(raw_tweets)
      inf.last_tweet_request = Time.now
      inf.save
      return true
    end

    false
  end

  def save_tweets(raw_tweets)
    raw_tweets.each do |s|
      h = Hash(s)
      Tweet.where(user: h[:user][:screen_name],
                  id_str: h[:id_str],
                  tx: h[:text],
                  tweet_time: DateTime.parse(h[:created_at]),
                  raw: h.to_json).first_or_create
    end
  end
end
