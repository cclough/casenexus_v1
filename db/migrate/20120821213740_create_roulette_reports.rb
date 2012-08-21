class CreateRouletteReports < ActiveRecord::Migration
  def change
	  create_table "roulette_reports", :force => true do |t|
	    t.string   "userip",           :null => false
	    t.string   "reporteruserip",   :null => false
	    t.datetime "timestamp",        :null => false
	    t.string   "username",         :null => false
	    t.string   "reporterusername", :null => false
	    t.datetime "created_at",       :null => false
	    t.datetime "updated_at",       :null => false
	  end
  end
end
