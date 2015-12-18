class StatisticsController < ApplicationController
  def show
    logger.debug("IN SHOW: " + params.to_s)
	@clinics = Clinic.all
    if params[:id] == "0"
		@all = true
	else
	    run_id = params[:id]
    	@run = Run.where(:id => run_id).first
    
	    logger.debug("RUN: " + @run.id.to_s)
		@all = false
	end
  end

  def new
		if params[:run_id] != nil
			Statistics::Utils.generate_stats_for_run(params[:run_id])
		end
  end
end
