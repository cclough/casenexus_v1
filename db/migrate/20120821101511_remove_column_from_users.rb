class RemoveColumnFromUsers < ActiveRecord::Migration
	def change
		remove_column :users, :city
		remove_column :users, :country
		add_column :users, :accept_tandc, :boolean, :default => false
	end
end
