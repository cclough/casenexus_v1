class StaticPagesController < ApplicationController
  # include all user session data e.g. notifications and username 
  before_filter :session_data

  def home
 	if signed_in?
		redirect_to users_path
	end
  end

  def help
  end

  def about
  end

  def contact
  end
end
