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
    update_influencers if Influencer.count <= 0

    @users = User.all
    @influencers = Influencer.all
    @tweets = Tweet.latest_tweets
    @display_user = Tweet.display_name
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
    influencer_list = %w(
        fakegrimlock kimjongnumberun thepresobama elbloombito Queen_UK
    DarthVader
    NotZuckerberg
    Lord_Voldemort7
    BoredElonMusk
    ItsWillyFerrell
    Charles_HRH
    FakeScience
    Plaid_Gaddafi)

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
