class User < ActiveRecord::Base
  include TwitterUser

  def self.from_omniauth(auth)
    filtered_params = auth.slice('provider', 'uid', 'info', 'extra')
    user_id_info = auth.slice('provider', 'uid')
    where(user_id_info.permit(:provider, :uid)).first || create_from_omniauth(filtered_params)
  end

  def self.create_from_omniauth(auth)
    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      user.name = auth['info']['nickname']
      user.raw = auth['extra']['raw_info'].to_json
    end
  end

  def latest_tweets; latest_tweets_for_user(name) end
  def profile_bg_url; @user_pic = raw_hash['profile_background_image_url'] end
  def user_pic_url; @user_pic = raw_hash['profile_image_url'] end
  def description; @description = raw_hash['description'] end
  def raw_hash; @raw_hash ||= JSON.parse(raw) end
end
