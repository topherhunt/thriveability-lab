require "test_helper"

class AccountsTest < Capybara::Rails::TestCase
  test "user registration & account management works" do
    visit root_path

    # user registration
    assert_equals 0, User.count
    click_on "Sign up"
    fill_in "user_first_name",            with: "Elmer"
    fill_in "user_last_name",             with: "Fudd"
    fill_in "user_email",                 with: "elmer.fudd@gmail.com"
    fill_in "user_password",              with: "foobar01"
    fill_in "user_password_confirmation", with: "foobar01"
    click_button "Sign up"
    assert_logged_in
    user = User.last

    # logging out
    click_on "Log out"
    assert_logged_out

    # Logging in
    click_on "Log in"
    fill_in "user[email]",    with: user.email
    fill_in "user[password]", with: "foobar01"
    click_button "Log in"
    assert_logged_in

    # changing password
    click_on "Account settings"
    fill_in "user_password",              with: "new-password01"
    fill_in "user_password_confirmation", with: "new-password01"
    fill_in "user_current_password",      with: "foobar01"
    click_on "Update"
    assert_equals true, user.reload.valid_password?("new-password01")
  end

  def assert_logged_in
    assert_content "Log out"
    assert_no_content "Log in"
  end

  def assert_logged_out
    assert_content "Log in"
    assert_no_content "Log out"
  end
end
