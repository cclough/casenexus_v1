class RemoveLocFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :loc
  end
end
