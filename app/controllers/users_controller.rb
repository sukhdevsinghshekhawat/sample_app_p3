class UsersController < ApplicationController
  before_action :logedin_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  
  def admin_user
    redirect_to(users_path) unless current_user.admin?
  end 

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "user deleted"
    redirect_to users_path
  end 

  def correct_user
    @user = User.find(params[:id]) 
    redirect_to(root_path) unless current_user_check?(@user)
  end 

  def show
    @user = User.find(params[:id])
    #debugger
  end 

  def index
    # @user = User.paginate(page: params[:page])
    @users = User.paginate(page: params[:page], per_page: 3)
  end

  def new
    @user = User.new
  end
  
  def edit
    @user = User.find(params[:id])
  end 

  def update
    @user = User.find(params[:id])
    if @user.update(param_require)
      flash[:success] = "update successful"
      redirect_to @user
    else
      render 'edit'
    end
  end 

  def create 
    @user = User.new(param_require)
    if @user.save
      login @user
      flash[:success] = "Welcome to the sample app"
      redirect_to @user
    else
      render 'new', status: :unprocessable_entity
    end 
  end

  def logedin_user
    unless logedin?
      user_rquest_otherpage_store
      flash[:alert] = "first login"
      redirect_to login_path
    end 
  end 


  private
  def param_require
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end 
end
