class RemoveThenAddColumnApprovedToPosts < ActiveRecord::Migration

  def change
  	remove_column :posts, :approved
    add_column :posts, :approved, :boolean, default: false
  end
  
end
