class RouletteRegistration < ActiveRecord::Base
   attr_accessible :username, :partner, :old_id, :status, :ip, :updatetime, :id
   
   attr_accessor :disabled, :reporterdisabled 
  # self.primary_key= :id
  

  # EVERYTHING IN THIS FILE IS WRITTEN BY VINCENT ZHU
  # He ported the videosoftware.pro flash roulette to Rails


  def self.process(args, ip)
    ret = "<?xml version='1.0' encoding='utf-8'?>\n"
    ret << "<result>\n"
    ret << "\t<action>#{args[:action]}</action>\n"
    begin
      if args[:code].start_with? $VALIDATION_CODE
        remove_all_phantom_users
      
        if args[:action] == 'register'
          register_user(args[:username], args[:id], nil, 'WAITING', ip)
        elsif args[:action] == 'unregister'
          register_user(args[:username], '0', nil, 'WAITING', ip)
        elsif args[:action] == 'lookup'
          if (partner = find_by_username args[:partner])
            ret <<  { :user => partner.username, :id => partner.old_id }.to_xml(:root => 'partner', :skip_instruct => true)
          else
            {:error => 'Partner could not be empty'}
            raise "Empty partner"
          end
         elsif args[:action] == 'ping'
            register_user(args[:username], args[:id], args[:partner], args[:status], ip)
          elsif args[:action] == 'list'
            ret << where("username <> '#{username}'").where("updatetime > '#{$VALID_INTERVAL.seconds.ago}'").order("username asc").collect do |r|
              {:user => r.username, :partner => r.partner}.to_xml(:root => 'list', :skip_instruct => true)
            end.join
          elsif args[:action] == 'find'
            partner = get_random_user_without_partner(args[:username])
            if partner
              ret << {:user => partner.username, :id => partner.old_id, :status => partner.status, :disabled => partner.disabled, :reporterdisabled => partner.reporterdisabled}.to_xml(:root => 'partner', :skip_instruct => true)
            end
          elsif args[:action] == 'report'
            report(args[:partner], args[:username], ip)
          else
            ret << "\t<error>Unhandled action type [#{args[:action]}]</error>\n"
            raise "Unhandled action type #{args[:action]}"
          end
      end
      ret << "\t<success>true</success>\n"
    rescue Exception => e
      logger.error e
      logger.error e.backtrace
      ret << "\t<success>false</success>\n"
    end
    ret << "</result>\n"
  end
  
  private 
  def self.remove_all_phantom_users
    self.where("updatetime <= '#{$VALID_INTERVAL.seconds.ago}'").delete_all
  end
  
  def self.get_random_user_without_partner(user_name)
  	  random_user = self.where("
  			username <> '#{user_name}' AND
  			updatetime > '#{$VALID_INTERVAL.seconds.ago}' AND
  			(
  				(partner is NULL AND status = 'WAITING') OR
  				(partner = '#{user_name}' AND status = 'CONNECTING')
  			)
  	").sample
  	
  	if random_user
    	  source_user = find_by_username(user_name)

        disabled = detect_abuse(random_user.username, random_user.ip)
        # reporter_disabled = detect_abuse(source_user.username, source_user.ip)
    		reporter_disabled = false

    		if ( random_user.status == "WAITING" ) 
    			status = "CONNECTING"
    		 else 
    			status = "WAITING"
  		  end
        source_user.partner = random_user.username
        source_user.status = status
        source_user.updatetime = Time.now
        source_user.save
      
      
        random_user.status = status
    		random_user.disabled = disabled ? "true" : "false"
    		random_user.reporterdisabled = reporter_disabled ? "true" : "false"
    		random_user.save
  	else 
  	  source_user = find_by_username(user_name)
  	  logger.debug user_name
  	  logger.debug source_user
  	  source_user.partner = nil
      source_user.status = "WAITING"
      source_user.updatetime = Time.now
      source_user.save
  	end
  	random_user
  end
  
  def self.detect_abuse(username, ip)
    num_reports = 0;
  	if $REPORTS_ABUSE_DETECTION_STRATEGY == "IP"
  	  num_reports = RouletteReport.report_num(ip)
  	 elsif  $REPORTS_ABUSE_DETECTION_STRATEGY == "USER" 
       num_reports = RouletteReport.report_num_by_name(username)
  	end

  	if ( num_reports >= $REPORTS_MAX_ALLOWED_PER_DAY ) 
  		return true
  	 else 
  		return false
  	end
  	
  end
  
  def self.register_user(user_name, id, partner, status, ip)
    logger.debug user_name
    source_user = find_or_initialize_by_username(user_name)
    logger.debug id
    if source_user
      source_user.username = user_name
      source_user.updatetime = Time.now
      source_user.partner = partner
      source_user.ip = ip
      source_user[:old_id] = id
      source_user.status = status
      source_user.save
    end

  end
  
  def self.report(user_name, reporter_user_name, remote_ip) 
    user, reporter = find_by_username([user_name, reporter_user_name])
    RouletteReport.create(userip: user.ip, reporteruserip: reporter.ip, timestamp: Time.now, username: user_name, reporterusername: reporter_user_name)
  end

end
