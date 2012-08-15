class AddColumnApprovedToPosts < ActiveRecord::Migration
	
	def change
		remove_column :posts, :approved
	end

  def change
    add_column :posts, :approved, :boolean, :default => false
  end
  
end
