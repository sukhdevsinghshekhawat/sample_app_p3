require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @basic_title = "Ruby on Rails Tutorial Sample App"
  end 

  test "should get root" do 
    get root_path 
    assert_response :success
    assert_select "title", "Home |#{@basic_title}"
  end 

  test "should get help" do
    get helps_path
    assert_response :success
    assert_select "title", "Help |#{@basic_title}"
  end

  test "about" do
    get about_path
    assert_response :success
    assert_select "title", "About |#{@basic_title}"
  end

  test "contact" do 
    get contact_path
    assert_response :success
    assert_select "title", "Contact |#{@basic_title}"
  end

  test "layout links" do 
    get root_path
    assert_template 'static_pages/home'
    assert_select 'a[href=?]', root_path, count: 2
    assert_select 'a[href=?]', about_path
    assert_select 'a[href=?]', helps_path
    assert_select 'a[href=?]', contact_path
    get contact_path
    assert_select "title", full_title("Contact")
  end

  test "full title" do 
    assert_equal full_title("Help"), "Help |Ruby on Rails Tutorial Sample App"  
  end 
end
