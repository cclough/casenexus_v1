class AddLocToUsers < ActiveRecord::Migration
  def change
    add_column :users, :loc, :string
  end
end
