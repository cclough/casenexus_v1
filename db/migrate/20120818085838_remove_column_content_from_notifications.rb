class RemoveColumnContentFromNotifications < ActiveRecord::Migration
	def change
		remove_column :notifications, :content
		add_column :notifications, :content, :text
	end
end
