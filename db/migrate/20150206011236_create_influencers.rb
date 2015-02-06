class CreateInfluencers < ActiveRecord::Migration
  def change
    create_table :influencers do |t|
      t.string :name
      t.string :handle
      t.string :id_str
      t.string :pic
      t.text :raw

      t.timestamps null: false
    end
  end
end
