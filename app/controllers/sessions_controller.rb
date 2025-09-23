class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user &.authenticate(params[:session][:password])
      if @user.activated?
        login @user
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
        backup_back(@user)
      else
        message = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end 
    else 
      flash.now[:danger] = "invalid Combination"
      render 'new'
    end
  end 

  def destroy
    logout if logedin?
    redirect_to root_url 
  end
end
