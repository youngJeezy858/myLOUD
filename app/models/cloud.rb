class Cloud < ActiveRecord::Base
  belongs_to :account
  has_one :ami
  attr_accessible :instance_id, :name, :subnet_id, :turn_off_at, :ami_id

  
  def create_instance(user)
    self.ami = Ami.where("imageId = ?", self.ami_id).last
    self.name = self.ami.name + "_#{user.login}"
    i = 2
    while !Cloud.find_by_name(name).nil?
      self.name = self.ami.name + "_#{user.login}" + "_#{i}"
      i = i + 1
    end
    
    self.turn_off_at = DateTime.now + 2.hours
    self.subnet_id = AWS_CONFIGS["subnet"]
    
    ec2 = AWS::EC2.new(:region => "us-west-2")
    instance = ec2.instances.create(
      :image_id => self.ami_id,
      :security_group_ids => user.account.security_group_id,
      :instance_type => "#{self.ami.size}",
      :subnet => subnet_id,
      :associate_public_ip_address => true )

    self.instance_id = instance.id
    ec2.client.create_tags(:resources => [self.instance_id], :tags => [
                              { :key => 'Name', :value => "#{self.name}" }])
    save!

    user.account.subtract_minutes(120)
  end


  def start_instance(user)
    instance = AWS::EC2.new(:region => "us-west-2").instances[self.instance_id]
    instance.start
    self.turn_off_at = DateTime.now + 2.hours
    user.account.subtract_minutes(120)
  end


  def stop_instance(user)
    instance = AWS::EC2.new(:region => "us-west-2").instances[self.instance_id]
    instance.stop
    user.account.credit(self.turn_off_at)
  end


  def reboot_instance
    instance = AWS::EC2.new(:region => "us-west-2").instances[self.instance_id]
    instance.reboot
  end


  def terminate_instance(user)
    instance = AWS::EC2.new(:region => "us-west-2").instances[self.instance_id]
    instance.terminate
    self.destroy
    user.account.credit(self.turn_off_at)
  end

end
