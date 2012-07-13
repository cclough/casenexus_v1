class MessagesController < ApplicationController

  before_filter :signed_in_user, only: [:map, :index, :edit, :update]
  before_filter :correct_user, only: [:edit, :update]

	def index
		@messages = current_user.messages.all
	end

end
