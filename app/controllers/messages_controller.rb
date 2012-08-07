class MessagesController < ApplicationController

  before_filter :signed_in_user, only: [:map, :index, :edit, :update]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: :destroy
  # include notifications instance var
  before_filter :session_data

	def index

    # build user messages, paginated, ordered
    #  get this to sort descending and paginate? 
		@messages = current_user.messages.paginate(per_page: 10, page: 
                params[:page], order: "created_at DESC")
	end

  def sent
    # get sent messages
    @sentmessages = Message.paginate(per_page: 10, page: 
                params[:page], order: "created_at DESC").find_by_sender_id(current_user.id)
  end

  def show
    @message = Message.find(params[:id])

    # get sender name from sender_id field
    @message_sender = User.find_by_id(@message.sender_id)
  end

  def create

    @message = Message.new(params[:message])

    # respond_to .js enables ajax create
    respond_to do |format|

      if @message.save

        # get User object from id supplied
        user_target = User.find(@message.user_id)
        # send message via email to target user
        UserMailer.message_email(user_target).deliver

        flash.now[:success] = 'Message sent!'
        format.js
      else
        # do I need the .html line below?
        format.html { render action: "new" }  
        format.js  
      end

    end

  end

end
