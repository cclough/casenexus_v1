class CasesController < ApplicationController
  before_filter :signed_in_user, only: [:map, :index, :edit, :update]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: :destroy

  # include notifications instance var
  before_filter :session_data

	def index

		# load in user's cases, paginated, ordered
		@cases = current_user.cases.paginate(per_page: 10, page: 
			     params[:page], order: "created_at DESC")
	end

	def analysis

		#### generate data for radar graph

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

		# LAST 5: load scores into json for radar chart
		@chartData_radar_last5 = "[{criteria: \"Plan\", score: " + @plan_avg.to_s + "},
							 {criteria: \"Analytical\", score: " + @analytic_avg.to_s + "},
							 {criteria: \"Structure\", score: " + @struc_avg.to_s + "},
							 {criteria: \"Conclusion\", score: " + @conc_avg.to_s + "}]"

		############# FIRST 5 ##############
		# FIRST 5: get last 5 cases by user
		@userCases_first5 = @user.cases.limit(5).order('id asc')

		# FIRST 5: calculate average scores for 4 criteria, from last 5 cases
		@plan_avg = @userCases_first5.collect(&:plan).sum.to_f/@userCases_first5.length
		@analytic_avg = @userCases_first5.collect(&:analytic).sum.to_f/@userCases_first5.length
		@struc_avg = @userCases_first5.collect(&:struc).sum.to_f/@userCases_first5.length
		@conc_avg = @userCases_first5.collect(&:conc).sum.to_f/@userCases_first5.length

		# FIRST 5: load scores into json for radar chart
		@chartData_radar_first5 = "[{criteria: \"Plan\", score: " + @plan_avg.to_s + "},
							 {criteria: \"Analytical\", score: " + @analytic_avg.to_s + "},
							 {criteria: \"Structure\", score: " + @struc_avg.to_s + "},
							 {criteria: \"Conclusion\", score: " + @conc_avg.to_s + "}]"

		#### generate data for progress chart

		# this could likely be done a lot better! .to_json?
		
        respond_to do |format|
      		format.html
      		# this is model stuff ...defining an action in the model...?
			format.json { render json: current_user.cases.order('date asc').map {|c|
						{ date: c.date.strftime("%Y-%m-%d"), plan: c.plan, analytic: c.analytic, 
						struc: c.struc, conc: c.conc } }}
    	end

	end

	def new
		@case = Case.new

		# if target is set, pass the id to the form, if not, error and re-direct
		if params[:target]
			@target = User.find_by_id(params[:target])
		else
			flash[:error] = "<strong>Error</strong> You must use the map 
							or the 'send feedback' page to select a 
							user to send feedback to".html_safe
			redirect_to users_path
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

	def create
	    @case = Case.new(params[:case])
	    # @case.marker_id = current_user.user_id

	  	if @case.save
	  		flash[:success] = "Feedback sent!"
	  		redirect_to cases_path
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
