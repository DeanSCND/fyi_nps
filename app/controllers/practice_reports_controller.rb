class PracticeReportsController < ApplicationController
	require 'csv'
	require 'json'

  	def index
      @runs = Run.where("fiscal_year is not null").order(id: :desc)
      @selected_run = Run.find(PracticeReport.maximum("run_id"))

  		@pResults = PracticeReport.summary_report_by_practices(@selected_run.id)
  		@gResults = PracticeReport.summary_report_by_groups(@selected_run.id)
      @prResults = PracticeReport.summary_report_by_provinces(@selected_run.id)
  		
      csv = @pResults

  		if params[:group] != nil
  			csv=@gResults
      elsif params[:prov] != nil
        csv=@prResults
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

      if params[:group] != nil
          csv=@gResults
      elsif params[:prov] != nil
        csv=@prResults
      end
      

    respond_to do |format|
      format.html
      format.csv { send_data PracticeReport.to_csv2(csv) }
      end
    end
end
