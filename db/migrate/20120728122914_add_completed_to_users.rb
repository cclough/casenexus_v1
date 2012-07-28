class AddCompletedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :completed, :boolean, :default => false
  end
end
