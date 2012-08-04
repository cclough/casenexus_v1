class ApplicationController < ActionController::Base
  protect_from_forgery

  # load all session methods
  include SessionsHelper

	# to load messages throughout session
	def show_messages

		# check if signed_in
		if signed_in?
			@messages_nav = current_user.messages.order('created_at desc').all(:limit => 5)
			@messages_count = current_user.messages.all.count
		end
		
	end

end
