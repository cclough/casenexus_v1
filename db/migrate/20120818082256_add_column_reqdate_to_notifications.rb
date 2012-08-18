class AddColumnReqdateToNotifications < ActiveRecord::Migration
  def change
  	add_column :notifications, :req_date, :date
   	add_column :notifications, :req_subject, :text
  end
end
