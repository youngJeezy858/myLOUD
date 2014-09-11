class Entitlement < ActiveRecord::Base
  belongs_to :account
  attr_accessible :name, :ip_address, :shutoff, :status, :ami

  def shutoff_expired_instances
    @entitlements = Entitlement.all
    @entitlements.each do |entitlement|
      if entitlement.shutoff > Time.now
### AWS KEY REQUIRED ###
#       instance = AWS::EC2.new.instances[entitlement.instance_id]
#       instance.stop
### TESTING - NO KEY ### 
        entitlement.status = "stopped"
########################  
        entitlement.save
      end
    end
  end

end
