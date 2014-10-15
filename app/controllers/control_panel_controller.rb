class ControlPanelController < ApplicationController
  def index
  end

  def download_key
    send_file Rails.root.join('private', 'loud.pem')
  end

  def instance_actions
    @cloud = Cloud.find(params[:id])

    respond_to do |format|
      format.js
    end
  end

end
