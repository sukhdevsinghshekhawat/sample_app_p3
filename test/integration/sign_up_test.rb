require "test_helper"

class SignUpTest < ActionDispatch::IntegrationTest
 
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "page test" do
    get new_path 
    assert_no_difference 'User.count' do 
      post users_path, params: {user: {name: " ", email: "exam23@gmail", password: "123", password_confirmation: "123456"}}
    end
    assert_template 'users/new'
    assert_select 'div#errors_explanation'
    assert_select 'div.field_with_errors'
  end 

  test "user diffrence" do
    get new_path 
    assert_difference 'User.count', 1 do 
      post users_path, params: {user: {name: "sanju singh", email: "sanju@gmail.com", password: "123456", password_confirmation: "123456"}}
    end 
    follow_redirect!
    # assert_template 'users/show'
    # assert_not  flash.empty?
  end

  test "user login successfully" do 
    get new_path
    assert_difference 'User.count', 1 do 
      post users_path, params: {user: {name: "sumansingh", email: "akash00@gmail.com", password: "123456", password_confirmation: "123456"} }
    end 
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = User.find_by(email: "akash00@gmail.com")
    assert_not user.activated?
    log_in_as(user)
    assert_not is_logged_in?
    user.activation_token = User.new_token
    user.activation_digest = User.digest(user.activation_token)
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    get edit_account_activation_path(user.activation_token, email: user.email)
  end 
end
