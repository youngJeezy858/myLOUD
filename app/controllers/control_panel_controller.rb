class ControlPanelController < ApplicationController
  def index
  end

  def download_key
    send_file Rails.root.join('private', 'loud.pem')
  end

  def instance_actions
    @cloud = current_user.account.clouds.first
    render :partial => 'instance_actions', :locals => { :cloud => @cloud } 
  end

end
