json.array!(@patients) do |patient|
  json.extract! patient, :id, :name, :email, :practice_id, :practiceName, :visitDate
  json.url patient_url(patient, format: :json)
end
