require '/usr/lib/lcsee-ldap/ldaplib'

class ApplicationController < ActionController::Base
  rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
    render :text => exception, :status => 500
  end
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :authenticate_user!

  def after_sign_in_path_for(user)
    admins = getEntry("cn", "sysstaff")
    admins.each do |attr, values|
      values.each do |value|
        if value.include? "uid=#{current_user.login},"
          current_user.update_attributes(:admin => true)
        end
      end
    end

    ec2 = AWS::EC2.new(:region => "us-west-2")
    groups = ec2.security_groups
    user_group = nil
    user_ip = "#{current_user.current_sign_in_ip}/32"
    if current_user.account.security_group_id.blank?
      groups.each do |group|
        if group.name == current_user.login
          user_group = group
          break
        end
      end
        
      user_group = groups.create(current_user.login, 
                                 {:vpc => AWS_CONFIGS["vpc"]}) if user_group == nil
      current_user.account.update_attributes(:security_group_id => user_group.id)
      
      user_group.egress_ip_permissions.each do |rule|
        rule.revoke
      end
      user_group.authorize_egress('0.0.0.0/0', :protocol => :tcp, :ports => 80..80)
      user_group.authorize_egress('0.0.0.0/0', :protocol => :tcp, :ports => 443..443)
    else
      user_group = groups[current_user.account.security_group_id]
    end
    user_group.ingress_ip_permissions.each do |rule|
      rule.revoke
    end
    user_group.authorize_ingress(:tcp, 22, user_ip)
    user_group.authorize_ingress(:tcp, 3000, user_ip)
    super    

  end  



end
