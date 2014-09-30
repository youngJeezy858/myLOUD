class AmisController < ApplicationController
  before_filter :authenticate_admin
  layout 'admin_tools'

  def index
    @amis = Ami.all
  end

  # GET /amis/1/edit
  def edit
    @ami = Ami.find(params[:id])
  end

  def show
    @ami = Ami.find(params[:id])
  end

  def new
    @ami = Ami.new
  end

  # POST /amis
  # POST /amis.json
  def create
    @ami = Ami.new(ami_params)

    respond_to do |format|
      if @ami.save
        format.html { redirect_to @ami, notice: 'Ami was successfully created.' }
        format.json { render action: 'show', status: :created, location: @ami }
      else
        format.html { render "admin_tools/index" }
        format.json { render json: @ami.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /amis/1
  # PATCH/PUT /amis/1.json
  def update
    @ami = Ami.find(params[:id])

    respond_to do |format|
      if @ami.update_attributes(ami_params)
        format.html { redirect_to @ami, notice: 'Ami was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @ami.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /amis/1
  # DELETE /amis/1.json
  def destroy
    @ami.destroy
    respond_to do |format|
      format.html { redirect_to amis_url }
      format.json { head :no_content }
    end
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
    def ami_params
      params.require(:ami).permit(:imageId, :name, :description, :size)
    end
    
    def authenticate_admin
      redirect_to root_path, notice: "You do not have access to that page!" unless current_user.admin
    end
    
end
