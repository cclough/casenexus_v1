class RouletteController < ApplicationController

    before_filter :signed_in_user

    # include notifications instance var
    before_filter :session_data

    # start session_Tracker
    before_filter :track_active_sessions

    def index
        # call in user data from session tracker gem (from redis)
        # number at the end defines minutes to look back
    end

    def random

        # get array of users (remember token codes store in track_active_sessions func below)
        @onlineusers = SessionTracker.new("onlineuser", $redis).active_users_data(1, Time.now)
        # random select one of them
        @selectonlineuser = @onlineusers[rand(@onlineusers.length)]
        # get user object from remember token
        # this is then used in the view
        @onlineuser = User.find_by_remember_token(@selectonlineuser)

        respond_to do |format|
          # don't load layout - make like a partial
          format.html { render :layout => false }
        end

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
