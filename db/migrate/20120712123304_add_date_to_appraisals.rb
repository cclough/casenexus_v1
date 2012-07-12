class AddDateToAppraisals < ActiveRecord::Migration
  def change
    add_column :appraisals, :date, :date, :after => :marker_id
  end
end