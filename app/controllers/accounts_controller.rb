class AccountsController < ApplicationController
  before_action :set_account, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate

  def new 
    @account = Account.new
  end

  def create
    @account = Account.new(params[:account])
    sg = AWS::EC2.new.security_groups.create(current_user.login)
    @account.security_group_id = sg.id
    @account.save
  end

  def index
    @accounts = Account.all
  end

  def edit
  end
 
  def show
    @entitlements = Entitlement.all
  end

  def update
    respond_to do |format|
      if @account.update(account_params)
        format.html { redirect_to @account, notice: 'Entitlement was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  def account_params
      params.require(:account).permit(:minutes, :instance_limit)
  end

  def set_account
    @account = Account.find(params[:id])
  end
  
  def authenticate
    redirect_to("/") unless current_user.admin
  end

end
