class ChangeTypeColumnInNotificationsToNtype < ActiveRecord::Migration
  def change
  	remove_column :notifications, :type
    add_column :notifications, :ntype, :string
  end
end
