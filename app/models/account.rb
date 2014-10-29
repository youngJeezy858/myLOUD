class Account < ActiveRecord::Base
  belongs_to :user
  has_many :entitlements
  has_many :clouds
  attr_accessible :minutes, :instance_limit, :entitlement_attributes, :security_group_id, :power_user, :total_usage


  def credit(turn_off_at)
    minutes_to_credit = turn_off_at.to_i - DateTime.now.to_i
    if minutes_to_credit > 0
      minutes_to_credit = minutes_to_credit / 60
      self.minutes = self.minutes + minutes_to_credit
      self.total_usage = self.total_usage - minutes_to_credit
      save!
    end
  end

  def subtract_minutes(minutes)
    if self.minutes > minutes
      self.minutes = self.minutes - minutes
    else
      self.minutes = 0
    end
    self.total_usage = self.total_usage + minutes
    save!
  end

end
