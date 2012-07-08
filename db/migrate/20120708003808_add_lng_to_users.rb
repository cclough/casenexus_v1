class AddLngToUsers < ActiveRecord::Migration
  def change
    add_column :users, :lng, :integer
  end
end
