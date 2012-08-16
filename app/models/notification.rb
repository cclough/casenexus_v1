class Notification < ActiveRecord::Base
  attr_accessible :ntype, :user_id, :sender_id, :content, :read

  belongs_to :user

  validates_presence_of :content, :user_id
  validates_presence_of :content, :sender_id
  validates_presence_of :content, :ntype
  validates_presence_of :content, :content
  validates_length_of   :content, maximum: 500

  default_scope order: 'created_at desc'
end
