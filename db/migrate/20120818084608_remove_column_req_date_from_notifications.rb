class RemoveColumnReqDateFromNotifications < ActiveRecord::Migration
	def change
		remove_column :notifications, :req_subject
		remove_column :notifications, :req_date
		add_column :notifications, :feedback_req_date, :date
	end
end
