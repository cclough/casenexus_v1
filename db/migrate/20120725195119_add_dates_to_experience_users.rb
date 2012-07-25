class AddDatesToExperienceUsers < ActiveRecord::Migration
  def change
    add_column :users, :education1_from, :date
    add_column :users, :education1_to, :date
    add_column :users, :education2_from, :date
    add_column :users, :education2_to, :date
    add_column :users, :education3_from, :date
    add_column :users, :education3_to, :date

    add_column :users, :experience1_from, :date
    add_column :users, :experience1_to, :date
    add_column :users, :experience2_from, :date
    add_column :users, :experience2_to, :date
    add_column :users, :experience3_from, :date
    add_column :users, :experience3_to, :date
  end
end
