class PracticeReportsController < ApplicationController
	require 'csv'
	require 'json'

  	def index
  		@pResults = PracticeReport.summary_report_by_practices
  		@gResults = PracticeReport.summary_report_by_groups
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
