class RemoveEmailAdminColumn < ActiveRecord::Migration
  def change
  	remove_column :users, :email_admin
   	remove_column :users, :email_users
    add_column :users, :emailadmin, :boolean, default: true
    add_column :users, :emailusers, :boolean, default: true
  end
end
