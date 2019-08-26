require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = users(:michael)
  end

  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "", password: "" } }
    assert_template 'sessions/new'
    assert_not flash.empty?, "expected flash to NOT be empty after bad request"

    get root_path
    assert flash.empty?, "expected flash to be empty after home redirect"
  end

  test "login with valid information followed by logout" do
    get login_path
    post login_path, params: { session: { email: @user.email,
                                          password: 'password' } }
    
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, { count: 0 }, message: "Expected no login links after already logging in"
    assert_select "a[href=?]", logout_path, message: "Expected logout link after logging in"
    assert_select "a[href=?]", user_path(@user), message: "Expected user link after logging in"

    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_select "a[href=?]", login_path, message: "Expected login link after logging out"
    assert_select "a[href=?]", logout_path, { count: 0 }, message: "Expected no logout link after already logging out"
    assert_select "a[href=?]", user_path(@user), { count: 0 }, message: "Expected no user link after logging out"
  end
end
