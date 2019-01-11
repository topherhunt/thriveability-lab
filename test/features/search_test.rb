require "test_helper"

class SearchTest < Capybara::Rails::TestCase
  setup do
    user1 = create(:user)
    project1 = create(:project)
    resource1 = create(:resource)
    convo1 = create(:conversation)

    mock_results = stub(
      total: 4,
      loaded_records: [user1, project1, resource1, convo1])

    RunSearch.stubs(call: mock_results)
  end

  test "user can search from the navbar" do
    visit root_path
    page.find(".test-navbar-search-input").set("horse")
    page.find(".test-navbar-search-submit").click
    assert_path search_path
    assert_content "4 results"
  end

  test "user can search from the on-page form" do
    visit search_path
    page.find(".test-search-input").set("kitten")
    page.find(".test-search-submit").click
    assert_content "4 results"
  end
end
