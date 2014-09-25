class Cloud < ActiveRecord::Base
  belongs_to :account
  attr_accessible :ami_id, :instance_id, :name, :subnet_id, :turn_off_at

  
  def create_instance(uid, sg_id)
    ami_name = ApplicationHelper.get_ami_name(ami_id)
    self.name = ami_name + "_#{uid}"
    i = 2
    while !Cloud.find_by_name(name).nil?
      self.name = ami_name + "_#{uid}" + "_#{i}"
      i = i + 1
    end
    
    self.turn_off_at = DateTime.now + 2.hours
    self.subnet_id = "subnet-aa7484dd"
    
    ec2 = AWS::EC2.new(:region => "us-west-2")
    instance = ec2.instances.create(
      :image_id => ami_id,
      :security_group_ids => sg_id,
      :instance_type => "t2.micro",
      :subnet => subnet_id,
      :associate_public_ip_address => true )

    self.instance_id = instance.id
    ec2.client.create_tags(:resources => [self.instance_id], :tags => [
                              { :key => 'Name', :value => "#{self.name}" }])
    save!
  end

  def terminate
    instance = AWS::EC2.new(:region => "us-west-2").instances[self.instance_id]
    instance.terminate
  end

end
