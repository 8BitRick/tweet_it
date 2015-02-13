class Influencer < ActiveRecord::Base
  include TwitterUser

  def latest_tweets; latest_tweets_for_user(handle) end
end
