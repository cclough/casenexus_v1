class CasesController < ApplicationController
  before_filter :signed_in_user

  # include all user session data e.g. notifications and username
  before_filter :session_data

	def index

		# load in user's cases, paginated, ordered
		@cases = current_user.cases.paginate(per_page: 10, page: 
			     	 params[:page], order: "created_at DESC")
		
	end

	def analysis

		#### Comments ####

		# using mapping for this - should be done in model?
		# marker_id to username conversion done in comment partial - saves repetition - may not be best tho
		@comments_plan = current_user.cases.all {|m| { marker_id: m.marker_id, created_at: m.created_at, plan_s: m.plan_s } }
		@comments_analytic = current_user.cases.all {|m| { marker_id: m.marker_id, analytic_s: m.analytic_s } }
		@comments_struc = current_user.cases.all {|m| { marker_id: m.marker_id, struc_s: m.struc_s } }
		@comments_conc = current_user.cases.all {|m| { marker_id: m.marker_id, conc_s: m.conc_s } }

		############# generate data for radar graph #############

		# load current user into object
		@user = current_user

		############# LAST 5 ##############
		# LAST 5: get last 5 cases by user
		@userCases_last5 = @user.cases.limit(5).order('id desc')

		# LAST 5: calculate average scores for 4 criteria, from last 5 cases
		@plan_avg = @userCases_last5.collect(&:plan).sum.to_f/@userCases_last5.length
		@analytic_avg = @userCases_last5.collect(&:analytic).sum.to_f/@userCases_last5.length
		@struc_avg = @userCases_last5.collect(&:struc).sum.to_f/@userCases_last5.length
		@conc_avg = @userCases_last5.collect(&:conc).sum.to_f/@userCases_last5.length


		############# FIRST 5 ##############
		# FIRST 5: get last 5 cases by user
		@userCases_first5 = @user.cases.limit(5).order('id asc')

		# FIRST 5: calculate average scores for 4 criteria, from last 5 cases
		@plan_avg_first5 = @userCases_first5.collect(&:plan).sum.to_f/@userCases_first5.length
		@analytic_avg_first5 = @userCases_first5.collect(&:analytic).sum.to_f/@userCases_first5.length
		@struc_avg_first5 = @userCases_first5.collect(&:struc).sum.to_f/@userCases_first5.length
		@conc_avg_first5 = @userCases_first5.collect(&:conc).sum.to_f/@userCases_first5.length

		# LAST 5: load scores into json for radar chart
		@chartData_radar = "[{criteria: \"Plan\", last5: " + @plan_avg.to_s + ", first5: " + @plan_avg_first5.to_s + "},
							 {criteria: \"Analytical\", last5: " + @analytic_avg.to_s + ", first5: " + @plan_avg_first5.to_s + "},
							 {criteria: \"Structure\", last5: " + @struc_avg.to_s + ", first5: " + @plan_avg_first5.to_s + "},
							 {criteria: \"Conclusion\", last5: " + @conc_avg.to_s + ", first5: " + @plan_avg_first5.to_s + "}]"

		#### generate data for progress chart
		
    respond_to do |format|
  		format.html
  		# this is model stuff ...defining an action in the model...?
			format.json { render json: current_user.cases.order('date asc').map {|c|
									{ date: c.date.strftime("%Y-%m-%d"), plan: c.plan, analytic: c.analytic, 
									struc: c.struc, conc: c.conc } }}
	
		end

	end

	def show
		@case = Case.find(params[:id])

		# data for radar graph
		@chart_data = "[{criteria: \"Plan\", score: "+@case.plan.to_s+"},
					   {criteria: \"Analytical\", score: "+@case.analytic.to_s+"},
					   {criteria: \"Structure\", score: "+@case.struc.to_s+"},
				       {criteria: \"Conclusion\", score: "+@case.conc.to_s+"}]"
	end

	def new

		# if target is set, pass the id to the form & build new case, 
		# if not, error and re-direct
		if params[:target]
			@user_target = User.find_by_id(params[:target])
			@case = @user_target.cases.build
		else
			flash[:error] = "<strong>Error</strong> You must use the map 
							or the 'send feedback' page to select a 
							user to send feedback to".html_safe
			redirect_to users_path
		end

	end

	def create
			
		# get target user
		@user_target = User.find_by_id(params[:case][:user_id])

		# build new case
		# not sure if this .build route (as opposed to just case.new) is neccessary
		# ...as we give it the user_id in a hidden field...but oh well
    	@case = @user_target.cases.build(params[:case])

	  	if @case.save
	  		# build new record in notification model
        	@user_target.notifications.create!(:ntype => "feedback_new",
                           					   :sender_id => current_user.id, 
                           					   :content => "You have received new feedback from #{current_user.name}")

	  		#### send email - new feedback
	  		# email variables
	  		url = "cases/" + @case.id.to_s
	  		subject = @case.subject
	  		date = @case.date

	  		# send email
      	UserMailer.feedback_new_email(@user_target, current_user, url, subject, date).deliver

      	# flash success and re-direct
	  		flash[:success] = "Feedback sent!"
	  		redirect_to users_path
	  	else
	  		render 'new'
	  	end

	end


	private

	# amchart date converter	
    def parseDate(dateString)

    	@dateArray = dateString.split("-")
			var date = Date(@dateArray[0].to_i, @dateArray[1].to_i - 1, @dateArray[2].to_i)
    	return date
		
		end

end
