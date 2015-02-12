class AddRawToUser < ActiveRecord::Migration
  def change
    add_column :users, :raw, :text
  end
end
