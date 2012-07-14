class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper


	# before_filter :track_active_sessions
	# def track_active_sessions
	#   SessionTracker.new("user", $redis).track(session[:session_id])
	# end


end
