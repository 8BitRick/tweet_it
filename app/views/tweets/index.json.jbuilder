json.array!(@tweets) do |tweet|
  json.extract! tweet, :id, :user, :id_str, :tx, :raw
  json.url tweet_url(tweet, format: :json)
end
