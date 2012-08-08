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
		@user = User.find_by_id(current_user.id)

		# get last 5 cases by user
		@user5cases = @user.cases.limit(5).order('id desc')

		# calculate average scores for 4 criteria, from last 5 cases
		@plan_avg = @user5cases.collect(&:plan).sum.to_f/@user5cases.length
		@analytic_avg = @user5cases.collect(&:analytic).sum.to_f/@user5cases.length
		@struc_avg = @user5cases.collect(&:struc).sum.to_f/@user5cases.length
		@conc_avg = @user5cases.collect(&:conc).sum.to_f/@user5cases.length

		# load scores into json for radar chart
		@chart_data_radar = "[{criteria: \"Plan\", score: " + @plan_avg.to_s + "},
							 {criteria: \"Analytical\", score: " + @analytic_avg.to_s + "},
							 {criteria: \"Structure\", score: " + @struc_avg.to_s + "},
							 {criteria: \"Conclusion\", score: " + @conc_avg.to_s + "}]"
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
		# @countries = Country.find(:all)

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

end
