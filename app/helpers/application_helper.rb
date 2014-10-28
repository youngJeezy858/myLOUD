module ApplicationHelper

  def get_ami_name(aws_id)
    Ami.find_by_imageId(aws_id).name
  end

  def self.get_ami_name(aws_id)
    Ami.find_by_imageId(aws_id).name
  end

  def format_minutes(minutes)
    (current_user.account.minutes / 60).to_s + ":" + 
      sprintf("%.2d", current_user.account.minutes % 60)
  end

  def format_time(time)
    time.strftime("%l:%M %p")
  end

  def get_instances(clouds)
    instances = Array.new
    return instances if clouds.empty?
    
    ids = ""
    if clouds.kind_of?(Array)
      ids = clouds.map(&:instance_id)
    else
      ids = clouds.pluck(:instance_id)
    end

    ec2 = AWS::EC2.new(:region => 'us-west-2')
    
    response = ec2.client.describe_instances(:instance_ids => ids)
    response[:reservation_set].each do |d|
      data = d[:instances_set].first
      cloud = clouds.find {|c| c.name == data[:tag_set].first[:value]}
      
      ip = data[:ip_address]
      status = data[:instance_state][:name]
      instance = {
        :owner => cloud.account.user.login,
        :created_at => cloud.created_at,
        :name => cloud.name,
        :id => cloud.id,
        :turn_off_at => cloud.turn_off_at,
        :ip_address => ip,
        :status => status
      }
      instance = OpenStruct.new instance
      instances << instance
    end
    
    instances
  end

  def get_ami_status(id)
    ec2 = AWS::EC2.new(:region => 'us-west-2')
    ec2.images[id].state
  end


  def active_if_welcome
    'active' if params[:controller] == 'welcome'
  end


  def active_if_control_panel
    'active' if params[:controller] == 'control_panel' or
      (['new','create'].include? params[:action] and params[:controller] == 'clouds')
  end


  def active_if_admin_tools
    'active' if params[:controller] =~ /admin_tools|accounts|amis/ or 
      (!['new','create'].include? params[:action] and params[:controller] == 'clouds')
  end

end
