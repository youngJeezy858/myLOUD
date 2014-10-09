class AccountsController < ApplicationController
  before_filter :set_account, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_admin
  layout 'admin_tools'
  

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
    @account = Account.find(params[:id])
  end

  def update
    respond_to do |format|
      if @account.update_attributes(account_params)
        format.html { redirect_to @account, notice: 'Account was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def account_params
      params.require(:account).permit(:minutes, :instance_limit, :power_user)
    end

    def set_account
      @account = Account.find(params[:id])
    end
    
    def authenticate_admin
      redirect_to :back, 
        notice: "You do not have permission to go to this page!" unless current_user.admin
    end

end
