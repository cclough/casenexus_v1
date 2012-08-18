class RemoveColumnDateFromNotifications < ActiveRecord::Migration
	
	def change
		remove_column :notifications, :feedback_req_date
		add_column :notifications, :event_date, :date
	end

end
