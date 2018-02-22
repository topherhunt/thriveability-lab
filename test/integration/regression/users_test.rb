require "test_helper"

class UsersTest < Capybara::Rails::TestCase
  test "new user registration works" do
    assert_equals 0, User.count
    visit new_user_registration_path
    fill_in 'user_email',                 with: "elmer.fudd@gmail.com"
    fill_in 'user_password',              with: "foobar01"
    fill_in 'user_password_confirmation', with: "foobar01"
    click_button "Sign up"
    assert_logged_in
    assert_equals 1, User.where(email: "elmer.fudd@gmail.com").count
  end

  context "with a registered user" do
    setup do
      @user = create(:user)
      login_as @user
    end

    test "user login and logout works" do
      assert_logged_in
      click_on "Log out"
      assert_logged_out
    end

    test "user change password form works" do
      click_on "Account settings"
      fill_in "user_password",              with: "new-password01"
      fill_in "user_password_confirmation", with: "new-password01"
      fill_in "user_current_password",      with: @user.password
      click_on "Update"
      assert_content "Your account has been updated"
      assert_equals true, @user.reload.valid_password?("new-password01")
    end

    test "user profile edit form works" do
      visit edit_user_path(@user)
      fill_in "user_first_name", with: "Elmer"
      page.find(".submit-user-profile").click
      assert_path user_path(@user)
      assert_equals "Elmer", @user.reload.first_name
    end
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
