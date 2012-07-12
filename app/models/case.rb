class Case < ActiveRecord::Base
  attr_accessible :user_id, :email, :marker_id, :date, :subject, :source, :plan, :plan_s,
  							  :analytic, :analytic_s, :struc, :struc_s, :conc, :conc_s,
  							  :comms, :comms_s, :comment, :notes

  belongs_to :user

  # validates_presence_of :content, :user_id
  # validates_length_of   :content, :maximum => 140
  # default_scope :order => 'created_at DESC'
end
