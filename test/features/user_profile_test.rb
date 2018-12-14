require "test_helper"

class UserProfileTest < Capybara::Rails::TestCase
  setup do
    @user = create :user
  end

  test "user profile viewing & editing works" do
    visit root_path
    login_as @user

    # editing my profile
    click_on "My Profile"
    page.find(".test-edit-user").click
    fill_in "user_name", with: "Elmer Fudd"
    page.find(".test-submit-user-profile").click
    assert_equals "Elmer Fudd", @user.reload.name

    # viewing my profile
    # TODO
  end
end
