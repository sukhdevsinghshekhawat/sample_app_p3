require "test_helper"

class SignUpTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
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
    assert_template 'users/show'
    assert_not  flash.empty?
  end 

  test "user login successfully" do 
    get new_path
    assert_difference 'User.count', 1 do 
      post users_path, params: {user: {name: "sumansingh", email: "suk00@gmail.com", password: "123456", password_confirmation: "123456" } }
    end 
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end 
end
