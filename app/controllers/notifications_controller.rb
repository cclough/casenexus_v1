class NotificationsController < ApplicationController
  before_filter :signed_in_user

  # include all user session data e.g. notifications and username
  before_filter :session_data

  def index

    # build user notifications, paginated, ordered
    #  get this to sort descending and paginate? 
  	@notifications = current_user.notifications.paginate(per_page: 10, page: 
              params[:page], order: "created_at DESC")
  end

  def sent
    # get sent notifications
    @notifications_sent = Notification.paginate(per_page: 10, page: 
                          params[:page], order: "created_at DESC")
                          .find_by_sender_id(current_user.id)
  end

  def show
    @notification = Notification.find(params[:id])

    # get sender name from sender_id field
    @notification_sender = User.find_by_id(@notification.sender_id)
  end

  def create

    # find incoming notification type
    @ntype = params[:notification][:ntype]

    # load new notification
    @notification = Notification.new(params[:notification])

    # respond_to .js enables ajax create
    respond_to do |format|

      if @notification.save

        # get User object from id supplied
        user_target = User.find(@notification.user_id)
        
        ######## EMAIL NOTIFICATION & UI JAVASCRIPT RESPONSES
        # EMAIL: Doing emailing (requiring an if statement) here to keep it out of other controllers
        # JAVASCRIPTS: javascript for each message type is specified here,
        #              this severely limits usage of this action
        #              later the js contents of these files should be put on e.g. just the map page

        # MESSAGE email
        if @ntype == "message"
          UserMailer.message_email(user_target, user_from, url).deliver
          # JS action to hide message form
          format.js { render :action => "create_messsage" }

        # FEEDBACK NEW email
        elsif @ntype == "feedback_new"
          UserMailer.feedback_new_email(user_target, user_from, url).deliver
          # (no JS action neccessary)

        # FEEDBACK REQUEST email
        elsif @ntype == "feedback_req"
          UserMailer.feedback_req_email(user_target, user_from, url).deliver
          # JS action to hide feedback request form
          format.js { render :action => "create_feedback_req" }

        end

        # might not need this flash
        flash.now[:success] = 'Notification sent & emailed!'
        
      else
        # if fails...
        # do I need the .html line below?
        format.html { render action: "new" }  
        format.js  
      
      end

    end


  end

end
