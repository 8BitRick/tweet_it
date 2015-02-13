class AddTweetTimeToTweets < ActiveRecord::Migration
  def change
    add_column :tweets, :tweet_time, :datetime
    add_index :tweets, :tweet_time
  end
end
