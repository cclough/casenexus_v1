class AddColumnUrlToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :url, :string
  end
end
