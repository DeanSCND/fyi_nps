json.array!(@practice_groups) do |practice_group|
  json.extract! practice_group, :id, :name
  json.url practice_group_url(practice_group, format: :json)
end
