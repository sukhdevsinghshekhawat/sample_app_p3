class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user &.authenticate(params[:session][:password])
      login @user
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      redirect_to @user
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
