class ControlPanelController < ApplicationController
  def index
  end

  def download_key
    send_file Rails.root.join('private', 'loud.pem')
  end

  def refresh
    respond_to do |format|
      format.html { render :partial => 'my_instance_list' }
      format.js { }
    end

  end

end
