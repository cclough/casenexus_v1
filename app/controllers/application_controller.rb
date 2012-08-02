class ApplicationController < ActionController::Base
  protect_from_forgery

  # load all session methods
  include SessionsHelper

	# to load messages through session
	def show_messages
		@messages_nav = Message.all(:limit => 5) 
		# .order('created_at desc')
	end

end
