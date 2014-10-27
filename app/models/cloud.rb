class Cloud < ActiveRecord::Base
  belongs_to :account
  attr_accessible :instance_id, :name, :subnet_id, :turn_off_at, :ami_id

  validate :instance_limit_reached?, :no_time_left?

  def instance_limit_reached?
    count = self.account.clouds.size
    limit = self.account.instance_limit
    errors[:base] << "You have already reached your limit " + 
      "for cLOUD instances. Please terminate " + 
      "one before starting another." if count > limit
  end


  def no_time_left?
    time_left = self.account.minutes
    errors[:base] << "You have no time left on your account" if time_left <= 0
  end

  
  def create_instance(user, runtime)
    ami = Ami.where("imageId = ?", self.ami_id).last
    self.name = ami.name + "_#{user.login}"
    i = 2
    while !Cloud.find_by_name(name).nil?
      self.name = ami.name + "_#{user.login}" + "_#{i}"
      i = i + 1
    end
    
    if runtime.nil?
      runtime = 2
    end
    
    self.turn_off_at = DateTime.now + runtime.hours
    self.subnet_id = AWS_CONFIGS["subnet"]
    
    ec2 = AWS::EC2.new(:region => "us-west-2")
    instance = ec2.instances.create(
      :image_id => self.ami_id,
      :security_group_ids => user.account.security_group_id,
      :instance_type => "#{ami.size}",
      :subnet => subnet_id,
      :associate_public_ip_address => true )

    self.instance_id = instance.id
    save!
    user.account.subtract_minutes(runtime * 60)

    ec2.client.create_tags(:resources => [self.instance_id], :tags => [
                              { :key => 'Name', :value => "#{self.name}" }])
  end


  def start_instance(user)
    instance = AWS::EC2.new(:region => "us-west-2").instances[self.instance_id]
    instance.start
  end


  def stop_instance(user)
    instance = AWS::EC2.new(:region => "us-west-2").instances[self.instance_id]
    instance.stop
  end


  def reboot_instance
    instance = AWS::EC2.new(:region => "us-west-2").instances[self.instance_id]
    instance.reboot
  end


  def terminate_instance(user)
    self.terminate
    user.account.credit(self.turn_off_at)
  end


  def self.terminate_idle
    clouds = where("turn_off_at < ?", DateTime.now)
    clouds.each do |cloud|
      cloud.terminate
    end
  end

  
  def terminate
    instance = AWS::EC2.new(:region => "us-west-2").instances[self.instance_id]
    instance.terminate
    self.destroy
  end

end
