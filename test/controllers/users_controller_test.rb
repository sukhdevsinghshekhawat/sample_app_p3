require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @basic_title = "Ruby on Rails Tutorial Sample App"
  end 

  test "should get new" do
    get root_path
    assert_response :success
    assert_select "title", "Home |#{@basic_title}"
  end

  test "full title check" do 
    get new_path
    assert_equal full_title("Sign up"), "Sign up |#{@basic_title}" 
    assert_select "title", full_title("Sign up")
  end
end
