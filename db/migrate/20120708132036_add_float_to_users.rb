class AddFloatToUsers < ActiveRecord::Migration
  def change
    remove_column :users, :lat
    remove_column :users, :lng	
    add_column :users, :lat, :float
    add_column :users, :lng, :float
  end
end
