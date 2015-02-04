class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  require 'twitter'

  def client
    @client ||= Twitter::REST::Client.new do |config|
      config.consumer_key        = 'YOUR_KEY_HERE'
      config.consumer_secret     = 'YOUR_KEY_SECRET_HERE'

      # TODO - get these from omniauth
      config.access_token        = '149759208-70XOOoJGlLflAq2filD8kStv6fqpqV0Jrbd7GbTB'
      config.access_token_secret = 'F70HdzbbeoPEOF2bbjPNLMNoa7vbv6tXxxdRKsTz1rQrZ'
    end
  end

  # TODO - move these into models
  def followers
    @followers ||= client.followers
    @followers.attrs[:users].map{|f| f[:name]}
  end

  def friends
    @friends ||= client.friends
    @friends.attrs[:users].map{|f| f[:name]}
  end

  def timeline
    @timeline ||= client.home_timeline
    @timeline.map{|t| t.full_text}
  end

  def mentions
    @mentions ||= client.mentions_timeline
    @mentions.map{|m| m.full_text}
  end

  def statuses
    @statuses ||= client.user_timeline(client.current_user).map{|t| t.full_text}
  end

  def temp
    fo = 'followers are ' + followers.to_s
    fr = 'friends are ' + friends.to_s
    ti = 'timeline is ' + timeline.to_s
    me = 'mentions ' + mentions.to_s
    st = 'statuses: ' + statuses.to_s

    str = [fo,fr,ti,me,st].join("\n")
    #str = client.methods.select{|t| t.to_s.downcase.include? 'tw'}
    #str = st
    puts str

    render plain: str
  end
end
