class WinnersController < ApplicationController

	def index
		@winners = Winner.all
	end

	def show
		@winner = Winner.find(params[:id])
	end
	
	def create
	    @winner = Winner.new(winner_params)

	    respond_to do |format|
	      if @winner.save
	        format.html { redirect_to @winner, notice: 'Clinic was successfully created.' }
	        format.json { render action: 'show', status: :created, location: @winner }
	      else
	        format.html { render action: 'new' }
	        format.json { render json: @winner.errors, status: :unprocessable_entity }
	      end
	    end
	end

	def winner_params
      params.require(:winner).permit(:run_id,:patient_id,:practice_id,:clinic_id,:name,:witness)
    end
end