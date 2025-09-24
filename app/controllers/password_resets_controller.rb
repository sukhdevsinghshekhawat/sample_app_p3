class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end
   
  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
      if@user
        @user.create_reset_digest
        @user.send_password_reset_email
        Rails.logger.debug "RESET CHECK FAILED for #{@user.email} id #{@user.reset_digest}" if @user
        flash[:info] = "Email sent with password reset instructions"
        redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new', status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    # debugger
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("error_explanation", partial: "shared/errors_messages", locals: {object: @user}) }
        format.html { render 'edit' }
      end
    elsif @user.update(user_params)
      login @user
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def get_user
    @user = User.find_by(email: params[:email])
  end

  def valid_user
    unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
      Rails.logger.debug "RESET CHECK FAILED for #{@user.email} id #{@user.reset_digest}" if @user
      redirect_to root_url
    end 
  end

  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = "Password reset has expired."
      redirect_to new_password_reset_url
    end
  end
end
