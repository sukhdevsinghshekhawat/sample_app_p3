class ApplicationController < ActionController::Base
	include SessionsHelper
	def logedin_user
    unless logedin?
      user_rquest_otherpage_store
      flash[:alert] = "first login"
      redirect_to login_path
    end 
  end 
end
