class AddColumnSkillToUsers < ActiveRecord::Migration
  def change
    add_column :users, :skill, :string
  end
end
