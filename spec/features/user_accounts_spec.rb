require 'rails_helper'
require 'support/feature_helpers'

describe "User accounts" do
  specify "visitor can register an account" do
    visit root_path
    click_link "Sign up"
    fill_in 'user_email',                 with: "elmer.fudd@gmail.com"
    fill_in 'user_password',              with: "foobar01"
    fill_in 'user_password_confirmation', with: "foobar01"
    click_button "Sign up"
    page.should have_link "Log out"
    page.should_not have_link "Sign up"
    page.should have_content "elmer.fudd@gmail.com"
  end

  specify "user can log in, change password, and log out" do
    @user = create(:user)

    log_in @user
    click_on "Account settings"
    fill_in "user_password",              with: "foobar02"
    fill_in "user_password_confirmation", with: "foobar02"
    fill_in "user_current_password",      with: @user.password
    click_on "Update"
    page.should have_content "Your account has been updated successfully."
    @user.reload.valid_password?("foobar02").should eq true
    click_on "Log out"
    page.should have_link "Log in"
    page.should_not have_link "Log out"
  end
end
