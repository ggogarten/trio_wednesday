json.array!(@candidates) do |candidate|
  json.extract! candidate, :id, :name, :party
  json.url candidate_url(candidate, format: :json)
end
