require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @basic_title = "Ruby on Rails Tutorial Sample App"
  end 

  test "should get root" do 
    get root_url 
    assert_response :success
    assert_select "title", "Home | #{@basic_title}"
  end 

  test "should get home" do
    get static_pages_home_url
    assert_response :success
    assert_select "title", "Home | #{@basic_title}"
  end

  test "should get help" do
    get static_pages_help_url
    assert_response :success
    assert_select "title", "Help | #{@basic_title}"
  end

  test "about" do
    get static_pages_about_url
    assert_response :success
    assert_select "title", "About | #{@basic_title}"
  end
end
