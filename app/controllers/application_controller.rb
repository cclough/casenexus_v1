class ApplicationController < ActionController::Base
  protect_from_forgery

  # load all session methods
  include SessionsHelper

	# to load various user variables throughout session
	def session_data

		# only if signed_in
		if signed_in?

			# current user name
			@user_name = current_user.name

			# notifications for header
			@user_notifications = current_user.notifications.order('created_at desc')
														.all(:limit => 5).reverse

			# notification count for header (switch to unread?)
			@user_notifications_count = current_user.notifications.all.count

			# user case count for header
			@user_cases_count = current_user.cases.all.count
		end
		
	end

end
