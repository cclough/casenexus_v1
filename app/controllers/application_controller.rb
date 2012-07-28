class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  	def show_messages
  		@messages = Message.all(:limit => 5)
  	end

end
