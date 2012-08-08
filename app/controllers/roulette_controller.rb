class RouletteController < ApplicationController

    before_filter :signed_in_user, only: [:map, :index, :edit, :update]
    before_filter :correct_user, only: [:edit, :update]
    before_filter :admin_user, only: :destroy

    # include notifications instance var
    before_filter :session_data

    # start session_Tracker
    before_filter :track_active_sessions

    def index
        # call in user data from session tracker gem (from redis)
        # number at the end defines minutes to look back
    end

    def show

        @onlineusers = SessionTracker.new("onlineuser", $redis).active_users_data(1, Time.now)
        @onlineuser = 

        - rand(@onlineusers.length)

        
        - @onlineuser = User.find_by_remember_token(t)

    end




    # start sessiontracker gem(redis) on user arriving to controller
    # store remember token in redis (could change for email or params[:session]?)
    def track_active_sessions
      # first insist that the skype field is completed in a users profile
      if current_user.skype.blank?
        # if blank, flash an error to update their profile
        flash.now[:error] = "You must add your skype username to
                             #{view_context.link_to 'your profile', edit_user_path(current_user)}
                             to use the roulette. If you do not 
                             have a Skype address, 
                             #{view_context.link_to 'register for one', 
                             'https://www.skype.com/go/join'}".html_safe
      
      else
        SessionTracker.new("onlineuser", $redis).track(current_user.remember_token)
      end
    end

end
