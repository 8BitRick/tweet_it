class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  require 'twitter'
  require 'pp'

  def welcome
    if(current_user)
      redirect_to '/tweet_it'
    end
  end

  def tweet_it
    @users = User.all
    @tweets = statuses
  end

  def post_tweet
    pp params
    client.update(params[:tweet_to_post])
    redirect_to '/tweet_it'
  end

  def client
    @client ||= Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_KEY']
      config.consumer_secret     = ENV['TWITTER_SECRET']
      config.access_token        = session['token']
      config.access_token_secret = session['secret']
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
    # TODO - HACKING TO prevent hitting twitter api too often
    @statuses = Tweet.where(user: current_user.name)
    return @statuses if @statuses

    raw_tweets = client.user_timeline(client.current_user)#.map{|t| t.full_text}
    raw_tweets.each do |s|
      h = Hash(s)
      Tweet.where(user: h[:user][:screen_name],
                  id_str: h[:id_str],
                  tx: h[:text],
                  raw: h.to_json).first_or_create
    end

    @statuses = Tweet.where(user: current_user.name)
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

    #render plain: str
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if (session && session[:user_id])
  end

  helper_method :current_user
end
