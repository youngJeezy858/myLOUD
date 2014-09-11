class ApplicationController < ActionController::Base
  rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
    render :text => exception, :status => 500
  end
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :authenticate_user!

  def after_sign_in_path_for(user)
    #admins = getEntry("cn", "sysstaff")
    #admins.each do |attr, values|
    #  values.each do |value|
    #    if value.include? "uid=#{current_user.login},"
    #      current_user.update_attributes(:admin => true)
    #    end
    #  end
    #end

    ##Edit security group
    ec2 = AWS::EC2.new(:region => "us-west-2")
    if current_user.account.security_group_id.blank?
      group = ec2.security_groups.create(current_user.login, {:vpc => "vpc-42844427"})
      current_user.account.update_attributes(:security_group_id => group.id)
      group.revoke_egress('0.0.0.0/0')
      group.authorize_egress('0.0.0.0/0', :protocol => :tcp, :ports => 80..80)
      group.authorize_egress('0.0.0.0/0', :protocol => :tcp, :ports => 443..443)
    else
      group = ec2.security_groups[current_user.account.security_group_id]
      group.revoke_ingress(:tcp, 22, "#{current_user.last_sign_in_ip}/32")
    end
    group.authorize_ingress(:tcp, 22, "#{current_user.current_sign_in_ip}/32")
    super    
  end  

end
