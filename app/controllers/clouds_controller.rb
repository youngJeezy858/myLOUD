class CloudsController < ApplicationController
  before_filter :authenticate_user, :only => [:start, :stop, :reboot, :destroy]
  before_filter :authenticate_admin, :only => [:index]
  layout 'admin_tools', :only => [:index]

  def index
    @clouds = Cloud.all
  end


  def new
    @cloud = Cloud.new
  end


  def create
    @cloud = current_user.account.clouds.new(cloud_params)

    respond_to do |format|
      if @cloud.save
        @cloud.create_instance(current_user, params[:runtime].to_i)
        format.html { redirect_to control_panel_path }
        format.json { head :no_content }
      else
        format.html { render action: "new" }
        format.json { render json: @cloud.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @cloud = Cloud.find(params[:id])
    @cloud.terminate_instance(current_user)
   

    flash[:notice] = @cloud.name + " was successfully destroyed"
    respond_to do |format|
      format.html { redirect_to control_panel_path, 
        notice: "#{@cloud.name} has been successully destroyed"  }
      format.json { head :no_content }
      format.js { }
    end
  end


  def start
    @cloud = Cloud.find(params[:id])
    @cloud.start_instance(current_user)

    render :partial => 'control_panel/instance_actions'
  end


  def stop
    @cloud = Cloud.find(params[:id])
    @cloud.stop_instance(current_user)

    render :partial => 'control_panel/instance_actions'
  end


  def reboot
    @cloud = Cloud.find(params[:id])
    @cloud.reboot_instance

    flash[:notice] = @cloud.name + " was successfully rebooted"
    render :partial => 'control_panel/instance_actions'
  end


  def create_cloud
    @cloud = Cloud.find(params[:id])
    ami_id = @cloud.create_ami
    redirect_to :back, notice: "AMI was successfully created"
  end


  private
    def cloud_params
      params.require(:cloud).permit(:ami_id)
    end


    def authenticate_user
      @cloud = Cloud.find(params[:id])
      unless current_user.admin? or current_user.account_id == @cloud.account_id
        redirect_to :back, notice: "You do not have permission to do that!"
      end
    end


    def authenticate_admin
      unless current_user.admin?
        redirect_to :back, notice: "You do not have permission to go to that page!"
      end
    end

end
