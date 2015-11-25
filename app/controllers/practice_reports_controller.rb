class PracticeReportsController < ApplicationController
	require 'csv'
	require 'json'

  	def index
      @runs = Run.where("fiscal_year is not null").order(id: :desc)
      @selected_run = Run.find(PracticeReport.maximum("run_id"))

  		@pResults = PracticeReport.summary_report_by_practices(@selected_run.id)
  		@gResults = PracticeReport.summary_report_by_groups(@selected_run.id)

      provinces = ["Alberta", "British Columbia", "Saskatchewan", "Manitoba", "Ontario", "Nova Scotia", "New Brunswick"]
  		
      csv = @pResults

  		groups = false
  		if params[:group] != nil
  			groups = true
  			csv=@gResults
  		end
  		

		respond_to do |format|
			format.html
			format.csv { send_data PracticeReport.to_csv2(csv) }
    	end

  	end

    def show
      @runs = Run.where("fiscal_year is not null").order(id: :desc)
      @selected_run = Run.find(params[:id])
      @pResults = PracticeReport.summary_report_by_practices(@selected_run.id)
      @gResults = PracticeReport.summary_report_by_groups(@selected_run.id)

      provinces = ["Alberta", "British Columbia", "Saskatchewan", "Manitoba", "Ontario", "Nova Scotia", "New Brunswick"]
      
      csv = @pResults

      groups = false
      if params[:group] != nil
        groups = true
        csv=@gResults
      end
      

    respond_to do |format|
      format.html
      format.csv { send_data PracticeReport.to_csv2(csv) }
      end
    end
end
