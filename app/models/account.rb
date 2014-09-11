class Account < ActiveRecord::Base
  belongs_to :user
  has_many :entitlements
  has_many :clouds
  attr_accessible :minutes, :instance_limit, :entitlement_attributes, :security_group_id
end
