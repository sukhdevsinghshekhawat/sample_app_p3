require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @basic_title = "Ruby on Rails Tutorial Sample App"
    @user = User.create!(name: "Mic Example", email: "michael@example.com",password: "password", password_confirmation: "password", admin: true, activated: true)
    @otheruser = User.create!(name: "Example", email: "ankur11@example.com",password: "password", password_confirmation: "password")
  end 

  test "should get new" do
    get root_path
    assert_response :success
    assert_select "title", "Home |#{@basic_title}"
  end

  test "full title check" do 
    get new_path
    assert_equal full_title("Sign up"), "Sign up |#{@basic_title}" 
    assert_select "title", full_title("Sign upform")
  end

  test "should go indexpage without login" do 
    get users_path
    assert_redirected_to login_url
  end 

  test "should redirect when no logged in" do 
    patch user_path(@user), params: {user: {name: @user.name, email: @user.email}}
    assert_not flash.empty?
    assert_redirected_to login_path
  end 

  test "admin not edit on the web" do 
    log_in_as(@otheruser)
    assert_not @otheruser.admin?
    patch user_path(@otheruser), params: {user: {password: "password", password_confirmation: "password", admin: true}}
    assert_not @otheruser.admin?
  end 

  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  test "destroy  logged in as a non-admin" do
    log_in_as(@otheruser)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_path
  end

  test "delete as a admin" do 
    log_in_as(@user)
    assert_difference 'User.count',-1 do
      delete user_path(@otheruser)
    end
  end 

  test "index as admin including pagination and delete links" do
    log_in_as(@user)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    first_page_of_users = User.paginate(page: 1, per_page: 3)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @user
        assert_select 'input[value=?]', 'delete'
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@otheruser)
    end
  end

  test "index as non-admin" do
    log_in_as(@otheruser)
    get users_path
    assert_select 'input[value=?]', 'delete', count: 0
  end

  test "should follow and unfollow a user" do
    michael = users(:sukhdev)
    archer = users(:ankur)
    assert_not michael.following?(archer)
    michael.follow(archer)
    assert michael.following?(archer)
    assert archer.followers.include?(michael)
    michael.unfollow(archer)
    assert_not michael.following?(archer)
  end

  test "should redirect following when not logged in" do
    get following_user_path(@user)
    assert_redirected_to login_url
  end

  test "should redirect followers when not logged in" do
    get followers_user_path(@user)
    assert_redirected_to login_url
  end
end
