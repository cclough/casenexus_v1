class CreateAppraisals < ActiveRecord::Migration
  def change
    create_table  :appraisals do |t|
	      t.integer :user_id
	      t.integer :marker_id
	      t.string	:subject
	      t.string  :source
	      t.integer :plan
	      t.string  :plan_s
	      t.integer :analytic 
	      t.string  :analytic_s
	      t.integer :struc
	      t.string  :struc_s
	      t.integer :conc
	      t.string  :conc_s
	      t.integer :comms
	      t.string  :comms_s
	      t.integer :imp 
	      t.string  :imp_s
	      t.string  :comment
	      t.string  :notes	      
      t.timestamps
    end
  end
end
