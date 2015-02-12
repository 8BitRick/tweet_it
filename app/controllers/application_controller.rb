class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include TwitterClient

  require 'twitter'
  require 'pp'

  def welcome
    if(current_user)
      redirect_to '/tweet_it'
    end
  end

  def tweet_it
    # Influencers will only be established once
    # TODO - add some way to refresh the leader list, esp if we make it dynamic
    pp followers
    update_influencers if Influencer.count <= 0

    @influencers = Influencer.all
    @last_user = Influencer.first.handle
    @display_user = @last_user
    @tweets = Tweet.where(user: @last_user)
    #@tweets = statuses
  end

  def update_tweets
    @tweets = Tweet.where(user: params[:user])
  end

  def post_tweet
    pp params
    client.update(params[:tweet_to_post])
    redirect_to '/tweet_it'
  end

  def update_influencers
    influencer_list = ['fakegrimlock','kimjongnumberun','thepresobama','elbloombito']

    # Save off our influencers
    influencer_list.each do |influencer|
      user_data = client.user(influencer)
      Influencer.where(
          name: user_data[:name],
          handle: user_data[:screen_name],
          description: user_data[:description],
          id_str: user_data[:id_str],
          pic: user_data[:profile_image_url],
          raw: user_data.to_json).first_or_create
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
    save_tweets(raw_tweets)

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
