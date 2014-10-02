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

  def format_turn_off_at(time)
    time.strftime("%l:%M %p")
  end

  def get_instance(id)
    ec2 = AWS::EC2.new(:region => 'us-west-2')
    ec2.instances[id]
  end

  def get_instance_status(id)
    ec2 = AWS::EC2.new(:region => 'us-west-2')
    ec2.instances[id].status
  end

  def get_instance_ip(id)
    ec2 = AWS::EC2.new(:region => 'us-west-2')
    ec2.instances[id].ip_address
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
