module TwitterUser
  def latest_tweets_for_user(user)
    Tweet.where(user: user).order(tweet_time: :desc).take(20)
  end
end
