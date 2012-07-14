class AddColumnEmailadminToUsers < ActiveRecord::Migration
  def change
    add_column :users, :email_admin, :boolean
    add_column :users, :email_users, :boolean
  end
end
