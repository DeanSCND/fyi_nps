class DashboardsController < ApplicationController
  	require 'fileutils'
  	require 'base64'

  	def index
  		if params[:run_id] != nil
        run_id = params[:run_id].to_i
      else
        run_id = SurveyAnswer.maximum("run_id")
      end

      @run = Run.find(run_id)
      @start_run = Run.find(5)
      @previous_run = Run.find(run_id.to_i-1) 

  		@fyiResults = PracticeReport.where(:practice_id=>0, :run_id=>run_id, :stat_type=>"rolling").first
		  @lastFyiResults = PracticeReport.where(:practice_id=>0, :run_id=>run_id-1, :stat_type=>"rolling").first


      @current_median = PracticeReport.find_by_sql("select median(n1) as n1, median(n2) as n2, median(n3) as n3, median(response_rate) as response_rate, sum(responses) as responses from practice_reports where run_id = " + @run.id.to_s + "and stat_type = 'rolling' and practice_id <> 0 and practice_group_id is null").first
      @last_median = PracticeReport.find_by_sql("select median(n1) as n1, median(n2) as n2, median(n3) as n3, median(response_rate) as response_rate, sum(responses) as responses from practice_reports where run_id = " + (@run.id-1).to_s + "and stat_type = 'rolling' and practice_id <> 0 and practice_group_id is null").first

		  @top_practice_data = PracticeReport.where(:run_id=>run_id, :stat_type=>"rolling").where("responses>?", 100).order("n3 DESC").take(5)
		  @bottom_practice_data = PracticeReport.where(:run_id=>run_id, :stat_type=>"rolling").where("responses>?", 100).order("n3 ASC").take(5)

  		@trend = PracticeReport.where(:practice_id=>0, :stat_type=>"rolling").order("run_id ASC")
      @median_trend = PracticeReport.find_by_sql("select run_id, median(n1) as n1, median(n2) as n2, median(n3) as n3, median(response_rate) as response_rate from practice_reports where stat_type = 'rolling' and practice_group_id is null and practice_id <> 0 group by run_id order by run_id ASC")

      nps1 = []
      nps2 = []
      nps3 = []
      resp = []

      len = 0
      @trend.each do |vals|
        nps1.push(vals.n1)
        nps2.push(vals.n2)
        nps3.push(vals.n3)
        resp.push(vals.response_rate)

        len=len+1
      end

      #@nps1_med = current_median.n1
      #@nps2_med = current_median.n2
      #@nps3_med = current_median.n3
      #@response_med = current_median.response_rate

      #nps1.pop
      #nps2.pop
      #nps3.pop
      #resp.pop

      #@nps1_last_med = last_median.n1
      #@nps2_last_med = last_median.n2
      #@nps3_last_med = last_median.n3
      #@response_last_med = last_median.response_rate

	end	

  def median(array)
    sorted = array.sort
    len = sorted.length
    return (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
  end
end