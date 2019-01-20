require "test_helper"

class ResourcesTest < Capybara::Rails::TestCase
  setup do
    @user = create(:user)
    sign_in @user
  end

  test "resource creation form works" do
    assert_equals 0, @user.resources.count
    visit new_resource_path
    fill_dummy_content
    page.find(".submit-resource-button").click
    assert_path resource_path(@user.resources.last)
    assert_equals 1, @user.resources.count
  end

  def fill_dummy_content
    page.find("#resource_title").set("My climate presentation")
    page.find("#resource_description").set("A presentation on climate change")
    page.find("#resource_source_name").set("Elmer Fudd")
    page.find("#resource_current_url").set("http://abc.def")
  end
end
