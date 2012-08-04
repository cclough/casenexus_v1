class StaticPagesController < ApplicationController
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
