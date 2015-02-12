class TweetsController < ApplicationController
  before_action :set_tweet, only: [:show, :edit, :update, :destroy]
  include TwitterClient

  # GET /tweets
  # GET /tweets.json
  def index
    user = params[:user]
    cache_updated = update_tweet_cache(user)

    if(user)
      if(cache_updated || user != @last_user)
        @tweets = Tweet.where(user: user).take(20)
      end

      @display_user = user
      @last_user = user
    else
      @tweets = Tweet.all.take(20)
      @display_user = 'All leader\'s'
      @last_user = nil
    end
  end

  def update_tweet_cache(user)
    inf = Influencer.find_by(handle: user)
    if(inf.nil?)
      return false
    end

    # Check if need to update tweet cache for this influencer
    if(inf.last_tweet_request.nil? || (inf.last_tweet_request > 2.minutes.ago))
      raw_tweets = client.user_timeline(user)
      save_tweets(raw_tweets)
      inf.last_tweet_request = Time.now
      return true
    end

    false
  end

  # GET /tweets/1
  # GET /tweets/1.json
  def show
  end

  # GET /tweets/new
  def new
    @tweet = Tweet.new
  end

  # GET /tweets/1/edit
  def edit
  end

  # POST /tweets
  # POST /tweets.json
  def create
    @tweet = Tweet.new(tweet_params)

    respond_to do |format|
      if @tweet.save
        format.html { redirect_to @tweet, notice: 'Tweet was successfully created.' }
        format.json { render :show, status: :created, location: @tweet }
      else
        format.html { render :new }
        format.json { render json: @tweet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tweets/1
  # PATCH/PUT /tweets/1.json
  def update
    respond_to do |format|
      if @tweet.update(tweet_params)
        format.html { redirect_to @tweet, notice: 'Tweet was successfully updated.' }
        format.json { render :show, status: :ok, location: @tweet }
      else
        format.html { render :edit }
        format.json { render json: @tweet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tweets/1
  # DELETE /tweets/1.json
  def destroy
    @tweet.destroy
    respond_to do |format|
      format.html { redirect_to tweets_url, notice: 'Tweet was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tweet
      @tweet = Tweet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tweet_params
      params.require(:tweet).permit(:user, :id_str, :tx, :raw)
    end
end
