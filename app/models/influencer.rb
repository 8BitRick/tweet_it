class Influencer < ActiveRecord::Base
  def latest_tweets
    Tweet.where(user: handle).order(tweet_time: :desc).take(20)
  end
end
