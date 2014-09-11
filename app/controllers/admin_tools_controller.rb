class AdminToolsController < ApplicationController
  before_filter :authenticate_admin

  def index
    @ami = Ami.new
  end

  private
  def authenticate_admin
    redirect_to admin_tools_path, 
         notice: "You do not have access to this page!" unless current_user.admin
  end

end
