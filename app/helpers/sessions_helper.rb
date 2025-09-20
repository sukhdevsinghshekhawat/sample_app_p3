module SessionsHelper
	def login(user)
		session[:user_id] = user.id
	end

	def logout
		forget(current_user)
		session.delete(:user_id)
		@current_user = nil
	end 

	def current_user
		if(user_id = session[:user_id])
			@current_user ||= User.find_by(id: session[:user_id])
		elsif(user_id = cookies.encrypted[:user_id])
			user = User.find_by(id: user_id)
			if user && user.authenticated?(cookies[:remember_token])
				login user
				@current_user = user 
			end
		end
	end

	def logedin?
		!current_user.nil?
	end

	def remember(user)
		user.remember
    cookies.permanent.encrypted[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end 

  def forget(user)
  	user.forget
  	cookies.delete(:user_id)
  	cookies.delete(:remember_token)
  end

  def current_user_check?(user)
    user && user == current_user
  end

  def user_rquest_otherpage_store
  	session[:forwarding_url] = request.original_url if request.get?
  end 

  def backup_back(defauls)
  	redirect_to(session[:forwarding_url] || defauls)
  	session.delete(:forwarding_url)
  end 
end