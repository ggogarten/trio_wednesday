json.array!(@concepts) do |concept|
  json.extract! concept, :id, :idea, :relevance, :speech_id
  json.url concept_url(concept, format: :json)
end
