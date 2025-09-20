require "test_helper"
class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:sukhdev)
  end
  test "index pagination " do 
    log_in_as(@user)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    User.paginate(page: 1, per_page: 3).each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
    end 
  end
end
