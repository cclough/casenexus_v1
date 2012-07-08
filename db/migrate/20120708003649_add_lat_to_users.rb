class AddLatToUsers < ActiveRecord::Migration
  def change
    add_column :users, :lat, :integer
  end
end
