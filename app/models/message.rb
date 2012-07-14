class Message < ActiveRecord::Base
  attr_accessible :user_id, :sender_id, :content

  belongs_to :user

  validates_presence_of :content, :user_id, :sender_id
  validates_length_of   :content, maximum: 140
  default_scope order: 'created_at ASC'
end
