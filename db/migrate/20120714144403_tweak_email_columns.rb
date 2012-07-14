class TweakEmailColumns < ActiveRecord::Migration
  def change
  	remove_column :users, :emailadmin
   	remove_column :users, :emailusers
    add_column :users, :email_admin, :boolean, default: true
    add_column :users, :email_users, :boolean, default: true
  end
end
