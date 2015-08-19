json.array!(@survey_results) do |survey_result|
  json.extract! survey_result, :id, :user_id, :status, :fid, :created, :ip, :location, :nps, :run, :collector, :a1, :a2, :a3, :a4, :a5, :a6comment, :posfeedback, :b1, :b2, :b3, :b4, :b5, :b6comment, :contact, :negfeedback
  json.url survey_result_url(survey_result, format: :json)
end
