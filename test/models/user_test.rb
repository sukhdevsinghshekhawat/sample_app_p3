require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = User.create(name: "sukhdev", email: "sukhdev@gmail.in", password: "sukhdev", password_confirmation: "sukhdev")
  end 

  test "name check" do 
    assert @user.valid?
  end 

  test "name nil  check" do 
    @user.name = "a" * 23
    assert_not @user.valid?
  end 

  test "email check" do 
    @user.email = "a" * 249 + "@gmail.com"
    assert_not @user.valid?
  end

  test "email format check" do 
    valid_email = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_email.each do |v| 
      @user.email = v 
      assert @user.valid?, "#{v.inspect} should be valid"
    end 
  end 

  test "email duplicate check" do 
    dup_user = @user.dup 
    @user.save
    assert_not dup_user.valid?
  end 

  test "email duble dot" do 
    @user.email = "foo@bar..com"
    assert_not @user.valid?
  end

  test "password blank check" do 
    @user.password = @user.password_confirmation = " " * 4
    assert_not @user.valid?
  end 
  test "password length check" do 
    @user.password = @user.password_confirmation = "a" * 4
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, "")
  end
end 
