require "test_helper"

class UserAccountsTest < Capybara::Rails::TestCase
  test "visitor can register an account" do
    visit root_path
    click_link "Sign up"
    fill_in 'user_email',                 with: "elmer.fudd@gmail.com"
    fill_in 'user_password',              with: "foobar01"
    fill_in 'user_password_confirmation', with: "foobar01"
    click_button "Sign up"
    assert_content "Log out"
    refute_content "Sign up"
    assert_content "elmer.fudd@gmail.com"
  end

  test "user can log in, change password, and log out" do
    @user = create(:user)

    login_as @user
    click_on "Account settings"
    fill_in "user_password",              with: "foobar02"
    fill_in "user_password_confirmation", with: "foobar02"
    fill_in "user_current_password",      with: @user.password
    click_on "Update"
    assert_content "Your account has been updated successfully."
    assert_equals true, @user.reload.valid_password?("foobar02")
    click_on "Log out"
    assert_content "Log in"
    refute_content "Log out"
  end
end
