class AddLastTweetRequestToInfluencers < ActiveRecord::Migration
  def change
    add_column :influencers, :last_tweet_request, :datetime
  end
end
