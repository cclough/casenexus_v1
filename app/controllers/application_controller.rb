class ApplicationController < ActionController::Base
  protect_from_forgery

  # load all session methods
  include SessionsHelper

  # start session_Tracker
  before_filter :track_active_sessions

  	# to load messages through session
  	def show_messages
  		@messages_nav = Message.all(:limit => 5) 
  		# .order('created_at desc')
  	end

  	# for redis whose online script
	def track_active_sessions
	  SessionTracker.new("user", $redis).track(current_user.name)
	end

end
