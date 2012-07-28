class StaticPagesController < ApplicationController
    before_filter :show_messages

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
