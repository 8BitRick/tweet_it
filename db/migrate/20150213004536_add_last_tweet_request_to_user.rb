class AddLastTweetRequestToUser < ActiveRecord::Migration
  def change
    add_column :users, :last_tweet_request, :datetime
  end
end
