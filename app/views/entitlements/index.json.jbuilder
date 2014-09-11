json.array!(@entitlements) do |entitlement|
  json.extract! entitlement, :id, :instanceId, :myId, :decription, :ipAddress, :status
  json.url entitlement_url(entitlement, format: :json)
end
