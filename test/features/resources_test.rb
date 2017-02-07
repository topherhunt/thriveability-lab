require "test_helper"

class ResourcesTest < Capybara::Rails::TestCase
  test "user can create a resource" do
    @user = create(:user)
    login_as @user
    visit resources_path
    page.find(".add-new-resource-link").click
    page.find("#resource_title").set("My climate presentation")
    page.find("#resource_description").set("A presentation on climate change")
    page.find("#resource_source_name").set("Elmer Fudd")
    page.find("#resource_current_url").set("http://abc.def")
    attach_file "resource[attachment]", "#{Rails.root}/public/test/leaders.pdf"
    check "resource[ownership_affirmed]"
    page.find(".submit-resource-button").click
    assert_path resources_path
    assert_equals 1, @user.created_resources.count
    @resource = @user.created_resources.first
    assert_equals "My climate presentation", @resource.title
    assert_equals "A presentation on climate change", @resource.description
    assert_equals "Elmer Fudd", @resource.source_name
    assert_equals "http://abc.def", @resource.current_url
    assert_equals "leaders.pdf", @resource.attachment_file_name
  end

  test "user can add resources from their profile page" do
    @user = create(:user)
    login_as @user
    visit user_path(@user)
    assert_equals 0, @user.created_resources.count
    click_on "Add a resource"
    page.find("#resource_title").set("My climate presentation")
    page.find("#resource_source_name").set("Elmer Fudd")
    page.find(".submit-resource-button").click
    assert_path user_path(@user)
    assert_equals 1, @user.created_resources.count
  end
end
