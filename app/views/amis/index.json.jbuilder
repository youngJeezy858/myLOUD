json.array!(@amis) do |ami|
  json.extract! ami, :id, :imageId, :name, :description
  json.url ami_url(ami, format: :json)
end
