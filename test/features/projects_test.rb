require "test_helper"

class ProjectsTest < Capybara::Rails::TestCase
  test "user can create a project, view it, and edit its details" do
    @user = create(:user)
    sign_in @user
    visit root_path
    click_on "Projects"
    page.find(".test-new-project-button").click
    fill_in "project[title]", with: "Gathering Acorns"
    fill_in "project[subtitle]", with: "Re-thinking squirrels"
    fill_in "project[desired_impact]", with: "Test desired impact"
    fill_in "project[contribution_to_world]", with: "Test contribution"
    fill_in "project[location_of_home]", with: "home location"
    fill_in "project[location_of_impact]", with: "zone of impact"
    attach_file "project[image]", "#{Rails.root}/public/test/elmerfudd.jpg"
    select "developing", from: "project[stage]"
    fill_in 'project[tag_list]', with: "foo,bar,baz"
    page.find(".test-save-button").click

    assert_text "Your project was added successfully"
    @project = Project.last
    assert_equals "Gathering Acorns", @project.title
    assert_equals @user, @project.owner
    assert_path project_path(@project)

    page.find(".test-edit-link").click
    fill_in "project[title]", with: "The Gathering Storm"
    page.find(".test-save-button").click
    assert_text "Your project was updated successfully"
    assert_equals "The Gathering Storm", @project.reload.title
  end

  test "user can browse & view a project created by another, but not edit it" do
    @project = create :project
    @user = create(:user)
    sign_in @user
    visit root_path
    click_on "Projects"
    assert_text @project.title
    click_on @project.title
    assert_path project_path(@project)
    assert_content @project.title
    refute_selector ".test-edit-project-link"
  end
end
