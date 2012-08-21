class CreateRouletteRegistrations < ActiveRecord::Migration
  def change
	  create_table "roulette_registrations", :force => true do |t|
	    t.string   "username",   :null => false
	    t.datetime "updatetime"
	    t.string   "old_id"
	    t.string   "partner"
	    t.string   "status",     :null => false
	    t.string   "ip",         :null => false
	    t.datetime "created_at", :null => false
	    t.datetime "updated_at", :null => false
	  end
  end
end
