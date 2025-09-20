require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup 
    @user = users(:sukhdev)
  end 

  test "unsuccessfull edit" do 
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: {user: {name: "sukh", email: "sukhdev@invalid", password:    "duk", password_confirmation: "dukhw"} }
    assert_template 'users/edit'
    assert_select 'div#errors_explanation', count: 1
    assert_select 'div.alert', count: 1
  end

  test "successfully edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    name = "sukhdevsin"
    email = "suk@gmail.com"
    patch user_path(@user), params: {user:{name: name, email: email, password: "12345", password_confirmation: "12345"}}
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal @user.name, name
    assert_equal @user.email, email
  end
 
  test "when no logedin" do 
    get edit_user_path(@user)
    assert_not flash.empty? 
    assert_redirected_to login_path
  end 

  test "update when no logedin" do 
    patch user_path(@user), params: {user: {name: @user.name, email: @user.name}}
    assert_not flash.empty?
    assert_redirected_to login_path
  end 

  test "successfully login after send edit page" do 
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    name = "samita"
    email = "smait@gmail.com"
    patch user_path(@user), params: {user: {name: name, email: email, password: "", password_confirmation: ""}}
    assert_redirected_to @user
    assert_not flash.empty?
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end     
end
