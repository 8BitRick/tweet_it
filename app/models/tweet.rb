class Tweet < ActiveRecord::Base
  include ActionView::Helpers::DateHelper

  def user_pic_url
    return @user_pic if @user_pic

    pp raw_hash
    @user_pic = raw_hash['user']['profile_image_url']
  end

  def created_time_in_words
    time_ago_in_words(created_time) + ' ago'
  end

  def raw_hash; @raw_hash ||= JSON.parse(raw) end
  def created_time; @created_time ||= raw_hash['created_at'] end
end
