
class Account < ActiveRecord::Base
  belongs_to :user
  has_many :entitlements
  has_many :clouds
  attr_accessible :minutes, :instance_limit, :entitlement_attributes, :security_group_id


  def credit(turn_off_at)
    minutes_to_credit = turn_off_at.to_i - DateTime.now.to_i
    minutes_to_credit = minutes_to_credit / 60
    self.minutes = self.minutes + minutes_to_credit
    save!
  end

  def subtract_minutes(minutes)
    self.minutes = self.minutes - minutes
    save!
  end

end
