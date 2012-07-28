class CasesController < ApplicationController
  before_filter :signed_in_user, only: [:map, :index, :edit, :update]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: :destroy
  # include notifications instance var
  before_filter :show_messages

	def index
		@cases = Case.all
	end

	def analysis

		# data for radar graph
		@chart_data_radar = "[{criteria: \"Plan\", score: 9},
									      {criteria: \"Analytical\", score: 9},
									      {criteria: \"Structure\", score: 9},
									      {criteria: \"Conclusion\", score: 9}]"
	end

	def new
		@case = Case.new
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
