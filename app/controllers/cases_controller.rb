class CasesController < ApplicationController
  before_filter :signed_in_user

	def index
		@cases = Case.all
	end

	def new
		@case = Case.new
	end

	def show
		@case = Case.find(params[:id])
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
