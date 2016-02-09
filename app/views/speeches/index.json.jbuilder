json.array!(@speeches) do |speech|
  json.extract! speech, :id, :date, :text, :candidate_id
  json.url speech_url(speech, format: :json)
end
