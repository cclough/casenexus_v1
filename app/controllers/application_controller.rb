class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  	def show_messages
  		@messages_nav = Message.all(:limit => 5) 
  		# .order('created_at desc')
  	end

end
