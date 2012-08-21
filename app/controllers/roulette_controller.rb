class RouletteController < ApplicationController
  before_filter :signed_in_user

  # include all user session data e.g. notifications and username
  before_filter :session_data


  def index
  end


  def registration
    action = CGI.parse(URI.parse(request.url).query)
    params[:action] = action['action'].first
    # status = params[:status]
    # username = params[:username]
    # time = params[:time]
    # code = params[:code]
    @result = RouletteRegistration.process(params, request.remote_ip)
    logger.debug @result
    render :text => @result
  end

  def configuration
    action = CGI.parse(URI.parse(request.url).query)
    params[:action] = action['action'].first
    result = (if params[:action] == 'request'
      { action: params[:action], config: {:ping_interval => $PING_INTERVAL, :request_config_interval => $REQUEST_CONFIG_INTERVAL, :invitation_sent_timeout => $INVITATION_SENT_TIMEOUT, :find_next_button_activation_timeout => $FIND_NEXT_BUTTON_ACTIVATION_TIMEOUT, :find_next_activation_timeout => $FIND_NEXT_ACTIVATION_TIMEOUT, :hide_age_male => $HIDE_AGE_MALE, :hide_age_female => $HIDE_AGE_FEMALE, :PROP_FILTER_DENSITY => $FILTER_DENSITY }, :success => true}
    else
      { action: params[:action], error: "Unhandled action type #{params[:action]}", :success => false}
    end).to_xml(:root => 'result')
    logger.debug result
    render :text => result
  end
  
  def configfile
    render 'configfile.xml', :content_type => 'application/xml'
  end

  
end
