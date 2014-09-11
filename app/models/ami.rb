class Ami < ActiveRecord::Base
  attr_accessible :imageId, :name, :description

  validates_uniqueness_of :name
  validate :unique_ami_id

  def unique_ami_id
    unless AWS::EC2.new(:region => 'us-west-2').images[imageId].exists?     
      errors.add(:imageId, "hasn't been created through the AWS console")
    end
  end

end
