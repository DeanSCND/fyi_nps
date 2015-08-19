class SummaryController < ApplicationController
    
	def index
		logger.debug("IN SHOW: " + params.to_s)	
		@clinics = Clinic.all

		#@results = SurveyAnswer.all(:conditions => 'EXTRACT(MONTH FROM visitDate) = 1')
		@results = SurveyAnswer.select('"survey_answers"."practice_id"' 
			.where('status=\'Complete\' and EXTRACT(MONTH FROM "patients"."visitDate") = 1')
			.joins('INNER JOIN "patients" ON "patients"."id" = "survey_answers"."patient_id"')
	end

  	def show 

  	end
end
