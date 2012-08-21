# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120821213740) do

  create_table "cases", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "marker_id",  :null => false
    t.date     "date"
    t.string   "subject"
    t.string   "source"
    t.integer  "plan"
    t.string   "plan_s"
    t.integer  "analytic"
    t.string   "analytic_s"
    t.integer  "struc"
    t.string   "struc_s"
    t.integer  "conc"
    t.string   "conc_s"
    t.integer  "comms"
    t.string   "comms_s"
    t.string   "comment"
    t.string   "notes"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "notifications", :force => true do |t|
    t.integer  "user_id"
    t.integer  "sender_id"
    t.string   "ntype"
    t.text     "content"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.string   "url"
    t.date     "event_date"
    t.boolean  "read",       :default => false
  end

  create_table "posts", :force => true do |t|
    t.integer  "user_id",                       :null => false
    t.text     "content"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "approved",   :default => false
  end

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

  create_table "roulette_reports", :force => true do |t|
    t.string   "userip",           :null => false
    t.string   "reporteruserip",   :null => false
    t.datetime "timestamp",        :null => false
    t.string   "username",         :null => false
    t.string   "reporterusername", :null => false
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name",                                :null => false
    t.string   "email",                               :null => false
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",            :default => false
    t.float    "lat"
    t.float    "lng"
    t.boolean  "email_admin",      :default => true
    t.boolean  "email_users",      :default => true
    t.string   "skill"
    t.string   "education1"
    t.string   "education2"
    t.string   "education3"
    t.string   "experience1"
    t.string   "experience2"
    t.string   "experience3"
    t.string   "skype"
    t.string   "linkedin"
    t.integer  "num"
    t.date     "education1_from"
    t.date     "education1_to"
    t.date     "education2_from"
    t.date     "education2_to"
    t.date     "education3_from"
    t.date     "education3_to"
    t.date     "experience1_from"
    t.date     "experience1_to"
    t.date     "experience2_from"
    t.date     "experience2_to"
    t.date     "experience3_from"
    t.date     "experience3_to"
    t.boolean  "completed",        :default => false
    t.boolean  "accept_tandc",     :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
