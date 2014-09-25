class EntitlementsController < ApplicationController
  before_filter :set_entitlement, :set_ip, only: [:show, :edit, :update, :destroy, :admin_destroy, :admin_start, :admin_stop, :start, :stop, :reboot, :increment_runtime, :decrement_runtime]
  before_filter :authenticate, :except => [:index, :show, :new, :create, :destroy, :start, :stop, :increment_runtime, :decrement_runtime]
  
  # GET /entitlements
  # GET /entitlements.json
  def index
    @entitlements = Entitlement.all
    set_ips
  end

  # GET /entitlements/1
  # GET /entitlements/1.json
  def show
    @instance = AWS::EC2.new.instances[@entitlement.instance_id]
  end

  # GET /entitlements/new
  def new
    @entitlement = Entitlement.new
    @amis = Ami.all
  end

  # GET /entitlements/1/edit
  def edit
    @amis = Ami.all
  end

  # POST /entitlements
  # POST /entitlements.json
  def create
    @entitlements = Entitlement.all
    @amis = Ami.all
    instanceCount = 0
    @entitlements.each do |e|
      if e.account_id == current_user.account.id
        instanceCount += 1
      end
    end
    if instanceCount >= current_user.account.instance_limit
      redirect_to entitlements_path
      return 1
    end

    @entitlement = Entitlement.create(entitlement_params)
    @entitlement.name = "#{current_user.login}%03d" % instanceCount
    @entitlement.account_id = current_user.account.id
    @entitlement.ip_address = current_user.current_sign_in_ip

### AWS KEY REQUIRED ###        
#    aws = AWS::EC2.new
#    security_ip = params[:ip_address].to_s() + '/0'
#    security_group = aws.security_groups.create(@entitlement.id.to_s)
#    security_group.authorize_ingress :tcp, 20130, "#{@entitlement.ip_address}/32"

#    @instance = AWS::EC2.new.instances.create(:image_id => @entitlement.ami,
#                                              :security_groups => security_group,
#                                              :instance_type => "t1.micro")
#    @entitlement.instance_id = @instance.id
#    @entitlement.security_group_id = security_group.id
### TESTING - NO KEY ###
    @entitlement.status = "running"
########################

    if current_user.account.minutes >= 120
      @entitlement.shutoff = Time.now + 2.hours
      current_user.account.minutes -= 120
    else
      @entitlement.shutoff = Time.now + current_user.account.minutes * 60
      current_user.account.minutes = 0
    end
    current_user.account.save

    respond_to do |format|
      if @entitlement.save
        format.html { redirect_to @entitlement, notice: 'Entitlement was successfully created.' }
        format.json { render action: 'show', status: :created, location: @entitlement }
      else
        format.html { render action: 'new' }
        format.json { render json: @entitlement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /entitlements/1
  # PATCH/PUT /entitlements/1.json
  def update
    respond_to do |format|
      if @entitlement.update(entitlement_params)
        format.html { redirect_to @entitlement, notice: 'Entitlement was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @entitlement.errors, status: :unprocessable_entity }
      end
    end
  end

  def stop
### AWS KEY REQUIRED ###
#    @instance = AWS::EC2.new.instances[@entitlement.instance_id]
#    @instance.stop()
### TESTING - NO KEY ###
    @entitlement.status = "stopped"
########################
    if @entitlement.shutoff > Time.now
      current_user.account.minutes += ((@entitlement.shutoff - Time.now) / 1.minute).round
      current_user.account.save
    end
    @entitlement.shutoff = ""
    @entitlement.save
    redirect_to(:back)
  end

  def admin_stop 
### AWS KEY REQUIRED ###
#    @instance = AWS::EC2.new.instances[@entitlement.instance_id]
#    @instance.stop()
### TESTING - NO KEY ###
    @entitlement.status = "stopped"
########################
    if @entitlement.shutoff > Time.now
      @account = Account.find(@entitlement.account_id)
      @account.minutes += ((@entitlement.shutoff - Time.now) / 1.minute).round
      @account.save
    end
    @entitlement.shutoff = ""
    @entitlement.save
    redirect_to(:back)
  end

  def start
### AWS KEY REQUIRED ###
#    @instance = AWS::EC2.new.instances[@entitlement.instance_id]
#    @instance.start()
### TESTING - NO KEY ###
    @entitlement.status = "running"
########################
    if current_user.account.minutes >= 120
      @entitlement.shutoff = Time.now + 2.hours
      current_user.account.minutes -= 120
    else
      @entitlement.shutoff = Time.now + current_user.account.minutes * 60
      current_user.account.minutes = 0
    end
    
    current_user.account.save
    @entitlement.save

    redirect_to(:back)
  end

  def admin_start
### AWS KEY REQUIRED ###
#    @instance = AWS::EC2.new.instances[@entitlement.instance_id]
#    @instance.start()
### TESTING - NO KEY ###
    @entitlement.status = "running"
########################
    @account = Account.find(@entitlement.account_id)
      
    if current_user.account.minutes >= 120
      @entitlement.shutoff = Time.now + 2.hours
      @account.minutes -= 120
    else
      @entitlement.shutoff = Time.now + current_user.account.minutes * 60
      @account.minutes = 0
    end

    @entitlement.save
    @account.save
    
    redirect_to(:back)
  end

  def reboot
### AWS KEY REQUIRED ###
#    @instance = AWS::EC2.new.instances[@entitlement.instance_id]
#    @instance.reboot()
########################
    redirect_to(:back)
  end
  
  # DELETE /entitlements/1
  # DELETE /entitlements/1.json
  def destroy
    if @entitlement.shutoff? and @entitlement.shutoff > Time.now
      current_user.account.minutes += ((@entitlement.shutoff - Time.now) / 1.minute).round
      current_user.account.save
    end
    
### AWS KEY REQUIRED ###
#    @instance = AWS::EC2.new.instances[@entitlement.instance_id]
#    @instance.terminate
########################
    
    @entitlement.destroy    
    respond_to do |format|
      format.html { redirect_to entitlements_path }
      format.json { head :no_content }
    end
  end

  def admin_destroy
    @account = Account.find(@entitlement.account_id)
    if @entitlement.shutoff? and @entitlement.shutoff > Time.now
      @account.minutes += ((@entitlement.shutoff - Time.now) / 1.minute).round
      @account.save
    end

### AWS KEY REQUIRED ###    
#    @instance = AWS::EC2.new.instances[@entitlement.instance_id]
#    @instance.terminate
########################
    
    @entitlement.destroy
    respond_to do |format|
      format.html { redirect_to(:back) }
      format.json { head :no_content }
    end
  end

  def increment_runtime
    @account = Account.find(@entitlement.account_id)
    if current_user.account.minutes >= 60
      @entitlement.shutoff = @entitlement.shutoff + 1.hours
      @account.minutes -= 60
    else
      @entitlement.shutoff = @entitlement.shutoff + current_user.account.minutes * 60
      @account.minutes = 0
    end
    @entitlement.save
    @account.save
    redirect_to(:back)
  end
    
  def decrement_runtime
    if @entitlement.shutoff - Time.now > 1.hours
      @account = Account.find(@entitlement.account_id)
      @account.minutes += 60
      @account.save
      @entitlement.shutoff = @entitlement.shutoff - 1.hours
      @entitlement.save
    end
    redirect_to(:back)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_entitlement
      @entitlement = Entitlement.find(params[:id])
    end

    def set_ip
      if current_user.account.id == @entitlement.account_id and 
          current_user.current_sign_in_ip != @entitlement.ip_address then
### AWS KEY REQUIRED ###
#        old_ip = @entitlement.ip_address.to_s      
#        security_group = AWS::EC2.new.security_groups[@entitlement.security_group_id]
#        security_group.revoke_ingress :tcp, 20130, "#{old_ip}/32"
#        security_group.authorize_ingress :tcp, 20130, "#{current_user.current_sign_in_ip}/32"
##################
        @entitlement.ip_address = current_user.current_sign_in_ip
        @entitlement.save
      end
    end

    def set_ips
      @entitlements.each do |entitlement|
        if current_user.account.id == entitlement.account_id and 
            current_user.current_sign_in_ip != entitlement.ip_address then
### AWS KEY REQUIRED ###
#        old_ip = entitlement.ip_address.to_s      
#        security_group = AWS::EC2.new.security_groups[entitlement.security_group_id]
#        security_group.revoke_ingress :tcp, 20130, "#{old_ip}/32"
#        security_group.authorize_ingress :tcp, 20130, "#{current_user.current_sign_in_ip}/32"
##################
          entitlement.ip_address = current_user.current_sign_in_ip
          entitlement.save
        end
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def entitlement_params
      params.require(:entitlement).permit(:ami)
    end

    def authenticate
      if current_user.admin == false and current_user.account.id != @entitlement.account_id then
        redirect_to("/") 
      end
    end
end
