require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "invalid signup information" do
    get signup_path
    assert_template 'users/new'
    
    assert_no_difference 'User.count' do
      post signup_path, params: { user: { name: "",
                                          email: "something@invalid",
                                          password: "foo",
                                          password_confirmation: "bar" } }
    end

    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert.alert-danger'
  end

  test "valid signup information" do
    get signup_path
    assert_template 'users/new'

    assert_difference 'User.count' do
      post signup_path, params: { user: { name: "Something Valid",
                                          email: "something@valid.com",
                                          password: "validpassword",
                                          password_confirmation: "validpassword" } }
    end

    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
  end

end
