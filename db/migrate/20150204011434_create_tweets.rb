class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :user
      t.string :id_str
      t.text :tx
      t.text :raw

      t.timestamps null: false
    end
  end
end
