class Notification < ActiveRecord::Base
  attr_accessible :ntype, :user_id, :sender_id, :content, :read, 
  				  :event_date, :url

  belongs_to :user

  validates_presence_of :content, :user_id
  validates_presence_of :content, :sender_id
  validates_presence_of :content, :ntype

  default_scope order: 'created_at desc'
end
