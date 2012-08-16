class ApplicationController < ActionController::Base
  protect_from_forgery

  # load all session methods
  include SessionsHelper

	# to load various variables throughout session
	def session_data

		# check if signed_in
		if signed_in?
			@user_name = current_user.name

			@user_notifications = current_user.notifications.order('created_at desc')
							.all(:limit => 5)
			@user_notifications_count = current_user.notifications.all.count

			@user_cases_count = current_user.cases.all.count
		end
		
	end





end
