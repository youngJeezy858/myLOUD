class ControlPanelController < ApplicationController


  def index
  end


  def generate_key
    respond_to do |format|
      format.js { }
    end
  end


  def send_key
    ec2 = AWS::EC2.new(:region => "us-west-2")
    key_pair = ec2.key_pairs[current_user.login]
    key_pair.delete if key_pair.exists?
    key_pair = ec2.key_pairs.create(current_user.login)
    send_data key_pair.private_key, :filename => current_user.login + '.pem'
  end


  def refresh
    respond_to do |format|
      format.html { render :partial => 'my_instance_list' }
      format.js { }
    end
  end

end
