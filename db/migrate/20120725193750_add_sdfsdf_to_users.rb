class AddSdfsdfToUsers < ActiveRecord::Migration
  def change
    add_column :users, :education1, :string
    add_column :users, :education2, :string
    add_column :users, :education3, :string

    add_column :users, :experience1, :string
    add_column :users, :experience2, :string
    add_column :users, :experience3, :string

    add_column :users, :skype, :string
    add_column :users, :linkedin, :string

    add_column :users, :num, :integer
  end
end
