class MessagesController < ApplicationController

  before_filter :signed_in_user, only: [:map, :index, :edit, :update]
  before_filter :correct_user, only: [:edit, :update]

	def index
		@messages = current_user.messages.all
	end

  def create

    # @message = current_user.messages.build(params[:message])

    # respond_to do |format|
    #   if @message.save
          # UserMailer.message_email(@user).deliver
    #     # flash[:success] = "Micropost created!"
    #     format.html { redirect_to @message, notice: 'Notification sent.' }  
    #     format.js  
    #   else
    #     format.html { render action: "new" }  
    #     format.js  
    #   end
    # end
  end

end
