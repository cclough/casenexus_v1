class AddCountryToUsers < ActiveRecord::Migration
  def change
  	remove_column :users, :loc
    add_column :users, :country, :string
  	add_column :users, :city, :string
  end
end
