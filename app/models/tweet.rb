class Tweet < ActiveRecord::Base
  include ActionView::Helpers::DateHelper

  def self.latest_tweets
    Tweet.order(tweet_time: :desc).take(20)
  end

  def self.display_name
    'All leader\'s'
  end

  def user_pic_url
    return @user_pic if @user_pic

    #pp raw_hash
    @user_pic = raw_hash['user']['profile_image_url']
  end

  def created_time_in_words
    time_ago_in_words(created_time) + ' ago'
  end

  def raw_hash; @raw_hash ||= JSON.parse(raw) end
  def created_time; @created_time ||= raw_hash['created_at'] end
end
