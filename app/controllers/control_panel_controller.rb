class ControlPanelController < ApplicationController
  def index
  end

  def download_key
    send_file Rails.root.join('private', 'loud.pem')
  end

  def refresh
    render :partial => 'control_panel/instance_actions' 
  end

end
