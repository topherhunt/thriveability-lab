require "test_helper"

class ResourcesTest < Capybara::Rails::TestCase
  setup do
    @user = create(:user)
  end

  test "user can add resources from their profile page" do
    login_as @user
    visit user_path(@user)
    assert_selector ".resource", count: 0
    click_on "Add a resource"
    fill_fields(
      "resource[title]" => "My grant proposal",
      "resource[description]" => "Interesting summary of blah",
      "resource[url]" => "http://abc.def")
    attach_file "resource[attachment]", "#{Rails.root}/public/test/leaders.pdf"
    check "resource[ownership_affirmed]"
    click_button "Save"
    assert_path user_path(@user)
    assert_selector ".resource", count: 1
    assert_content "My grant proposal"
    assert_equals 1, @user.created_resources.count
    expect_attributes(@user.created_resources.first,
      title: "My grant proposal",
      description: "Interesting summary of blah",
      url: "http://abc.def",
      attachment_file_name: "leaders.pdf")
  end
end
