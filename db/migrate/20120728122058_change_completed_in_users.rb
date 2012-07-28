class ChangeCompletedInUsers < ActiveRecord::Migration
	def change
		remove_column :users, :completed
	end
end
