class User < ActiveRecord::Base
  def self.from_omniauth(auth)
    filtered_params = auth.slice('provider', 'uid', 'info')
    user_id_info = auth.slice('provider', 'uid')
    where(user_id_info.permit(:provider, :uid)).first || create_from_omniauth(filtered_params)
  end

  def self.create_from_omniauth(auth)
    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      user.name = auth['info']['nickname']
    end
  end
end
