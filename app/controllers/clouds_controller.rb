class CloudsController < ApplicationController
  before_filter :check_cloud_count, :only => [:create] 
  before_filter :authenticate_user, :only => [:start, :stop, :reboot, :destroy]
  before_filter :authenticate_admin, :only => [:index]
  layout 'admin_tools', :only => [:index]

  def index
    @clouds = Cloud.all
  end


  def new
    @cloud = Cloud.new
    @amis = Ami.all
  end


  def create
    @cloud = current_user.account.clouds.new(cloud_params)
    @cloud.create_instance(current_user)

    respond_to do |format|
      if @cloud.save
        format.html { redirect_to control_panel_path, notice: 'Instance was successfully started.' }
      else
        format.html { render action: "new" }
        format.json { render json: @cloud.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @cloud = Cloud.find(params[:id])
    @cloud.terminate_instance(current_user)
   
    respond_to do |format|
      format.html { redirect_to control_panel_path, 
        notice: "#{@cloud.name} has been successully destroyed"  }
      format.json { head :no_content }
    end
  end


  def start
    @cloud = Cloud.find(params[:id])
    @cloud.start_instance(current_user)

    redirect_to :back,
      notice: "#{@cloud.name} was successfully booted!"
  end


  def stop
    @cloud = Cloud.find(params[:id])
    @cloud.stop_instance(current_user)

    redirect_to :back,
      notice: "#{@cloud.name} is shutting down!"
  end


  def reboot
    @cloud = Cloud.find(params[:id])
    @cloud.reboot_instance

    redirect_to :back,
      notice: "#{@cloud.name} successfully rebooted!"
  end


  private
    def cloud_params
      params.require(:cloud).permit(:ami_id)
    end

    def check_cloud_count
      @clouds = current_user.account.clouds
      unless @clouds.nil?
        redirect_to control_panel_path, notice: "You have reached your instance limit. Please terminate your other instances before creating a new one!" if @clouds.size >= current_user.account.instance_limit
      end
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
