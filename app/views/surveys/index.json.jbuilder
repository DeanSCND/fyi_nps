json.array!(@surveys) do |survey|
  json.extract! survey, :id, :run, :count, :month, :status
  json.url survey_url(survey, format: :json)
end
