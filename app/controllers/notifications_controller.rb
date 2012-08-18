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
        user_from = current_user
        url_root = "https://radiant-shore-5325.herokuapp.com/"
        ######## EMAIL NOTIFICATION & UI JAVASCRIPT RESPONSES
        # EMAIL: Doing emailing (requiring an if statement) here to keep it out of other controllers
        # JAVASCRIPTS: javascript for each message type is specified here,
        #              this severely limits usage of this action
        #              later the js contents of these files should be put on e.g. just the map page

        # MESSAGE stuff
        if @ntype == "message"
          #url is simply to the message ID
          url = url_root + "notifications/" + @notification.id.to_s

          #message content
          message = @notification.content

          UserMailer.message_email(user_target, user_from, url, message).deliver

          # JS action to hide message form
          format.js { render :action => "create_message" }

        # FEEDBACK NEW stuff
        elsif @ntype == "feedback_new"
          #url is notification ID
          url = url_root + "notifications/" + @notification.id.to_S

          # feedback new stuff
          subject = @notification.content
          date = @notification.event_date

          UserMailer.feedback_new_email(user_target, user_from, url, subject, date).deliver

          # (no JS action neccessary)

        # FEEDBACK REQUEST stuff
        elsif @ntype == "feedback_req"
          #url is to new case form, including subject and date
          url = url_root + "cases/new?subject=" + @notification.content
                + "&date=" + @notification.date

          # feedback request stuff
          subject = @notification.content
          date = @notification.event_date

          UserMailer.feedback_req_email(user_target, user_from, url, subject, date).deliver

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
