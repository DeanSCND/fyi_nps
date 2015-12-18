class PracticeReport < ActiveRecord::Base
	belongs_to :clinic, :foreign_key=>:practice_id
	belongs_to :run

	def self.fyi_median_scores(run_id)
		PracticeReport.find_by_sql("select median(n1) as n1, median(n2) as n2, median(n3) as n3 from practice_reports where run_id = #{run_id} and stat_type = 'rolling'
		and practice_id <> 0 and practice_id is not null")
	end

	def self.summary_report_by_practices(run_id)
		PracticeReport.find_by_sql ["select c.name, c.practice_id, n1, n2, n3, responses, response_rate, pr.run_id, r.quarter, r.fiscal_year 
from practice_reports pr, clinics c, runs r
where pr.practice_id = c.practice_id
and pr.run_id = r.id
and pr.stat_type = 'rolling'
and pr.run_id = ?
order by c.practice_id, pr.run_id", run_id]
	end

	def self.summary_report_by_groups(run_id)
		PracticeReport.find_by_sql ["select g.name, g.practice_code as practice_id, n1, n2, n3, responses, response_rate, pr.run_id, r.quarter, r.fiscal_year
from practice_reports pr, practice_groups g, runs r
where pr.practice_group_id = g.id
and pr.run_id = r.id
and pr.stat_type = 'rolling'
and pr.run_id = ?
order by g.practice_code, pr.run_id", run_id]
	end

	def self.summary_report_by_provinces(run_id)
		PracticeReport.find_by_sql ["select pr.province as name, 0 as practice_id, n1, n2, n3, responses, response_rate, pr.run_id, r.quarter, r.fiscal_year 
from practice_reports pr, runs r
where pr.run_id = r.id
and pr.stat_type = 'rolling'
and pr.run_id = ?
and pr.province is not null 
order by pr.province, pr.run_id", run_id]
	end

	def self.to_csv2(results)
	      logger.debug("HERE")
	    CSV.generate do |csv|
	      csv << ["id", "Name", "Run Id", "NPS1", "NPS2", "NPS3", "Responses", "Response Rate"]
	      logger.debug("HERE")
	      results.each do |pr|
	        csv << pr.attributes.values_at(*["practice_id", "name", "run_id", "n1", "n2", "n3", "responses", "response_rate"])
	      end
	    end
	end
end
