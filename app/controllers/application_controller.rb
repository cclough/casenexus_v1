class ApplicationController < ActionController::Base
  protect_from_forgery

  # load all session methods
  include SessionsHelper

	# to load messages throughout session
	def session_data

		# check if signed_in
		if signed_in?
			@user_name = current_user.name

			@user_messages = current_user.messages.order('created_at desc')
							.all(:limit => 5)
			@user_messages_count = current_user.messages.all.count

			@user_cases_count = current_user.cases.all.count
		end
		
	end





end
