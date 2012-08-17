class RemoveColumnEmailFromCases < ActiveRecord::Migration
   def change
  	remove_column :cases, :email
  end
end
