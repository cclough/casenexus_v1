class AddEmailColumnToAppraisals < ActiveRecord::Migration
  def change
    add_column :appraisals, :email, :string
  end
end
