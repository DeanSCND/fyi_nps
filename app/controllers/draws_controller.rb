class DrawsController < ApplicationController

	def index
		run_id=params[:run_id].to_i

		#see if there is a winner

		winner = Winner.where(:run_id => run_id).first
		@is_winner = false

		if (winner != nil) 
			@is_winner = true

			redirect_to "/winners/" + winner.id.to_s
		else
			@winner = Winner.new
			@winner.run_id = run_id
		end

	end

	def show

	end
end