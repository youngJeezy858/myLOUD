class Ami < ActiveRecord::Base
  attr_accessible :imageId, :name, :description, :size

  validates_uniqueness_of :name
  validate :unique_ami_id

  def unique_ami_id
    if description.blank? and name.blank?
      unless AWS::EC2.new(:region => 'us-west-2').images[imageId].exists?     
        errors.add(:imageId, "hasn't been created through the AWS console")
      end
    end
  end

  
  def build(instance_id)
    ec2 = AWS::EC2.new(:region => "us-west-2")
    ami = ec2.images.create(:name => self.name,
                            :instance_id => instance_id,
                            :description => self.description)
    ami.image_id
  end


  def get_data
    ec2 = AWS::EC2.new(:region => "us-west-2")
    ami = ec2.images[self.imageId]
    self.description = ami.description
    self.name = ami.name
    self.save
  end


end
