require "test_helper"

class SearchTest < Capybara::Rails::TestCase
  setup do
    @user1 = create :user
    @project1 = create :project, title: "Apple Horse"
    @resource1 = create :resource, title: "Horse Kitten"
    @convo1 = create :conversation, title: "Kitten Dog"
    @comment1 = create :comment, context: @convo1
    @convo2 = create :conversation, title: "Dog Elephant"
    @comment2 = create :comment, context: @convo2
    Searcher.rebuild_es_index!
  end

  test "search interface works" do
    visit root_path

    # searching from navbar
    page.find(".test-navbar-search-input").set("horse")
    page.find(".test-navbar-search-submit").click
    assert_path search_path
    assert_content @project1.title
    assert_html project_path(@project1)
    assert_content @resource1.title
    assert_no_content @user1.full_name
    assert_no_content @convo1.title
    assert_no_content @convo2.title

    # searching from the results page form
    page.find(".test-search-input").set("kitten")
    page.find(".test-search-submit").click
    assert_content @convo1.title
    assert_content @resource1.title
    assert_no_content @convo2.title
    assert_no_content @user1.full_name
    assert_no_content @project1.title
  end
end
