class CreateTableCases < ActiveRecord::Migration

  def change
  	drop_table :cases
    create_table :cases do |t|
	    t.integer :user_id
	    t.string  :email
	    t.integer :marker_id
	    t.date    :date
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
	    t.string  :comment
	    t.string  :notes     
	  	t.timestamps
    end
  end

end
