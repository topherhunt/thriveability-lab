require "test_helper"

class ProjectsTest < Capybara::Rails::TestCase
  setup do
    @user = create(:user)
    @project = create(:project, owner: @user)
  end

  test "User can create a project" do
    login_as @user
    click_on "Projects"
    page.find(".test-new-project-button").click
    fill_in "project[title]", with: "Gathering Acorns"
    fill_in "project[subtitle]", with: "Re-thinking squirrels"
    fill_in "project[introduction]", with: "Foo bar baz! " * 100
    fill_in "project[call_to_action]", with: "Moneys! Moneys!"
    attach_file "project[image]", "#{Rails.root}/public/test/elmerfudd.jpg"
    select "developing", from: "project[stage]"
    click_on "Save"
    @project = Project.last
    assert_path project_path(@project)
    assert_content "Your new project is now publicly listed."
    assert_equals "Gathering Acorns", @project.title
    assert_equals "developing", @project.stage
  end

  test "Visitor can explore existing projects" do
    @project2 = create(:project, quadrant_ul: "Because it's art")
    @project3 = create(:project)

    visit root_path
    click_on "Projects"
    assert_content @project.title
    assert_content @project2.title
    assert_content @project3.title
    click_on @project2.title
    assert_path project_path(@project2)
    assert_content @project2.title
    assert_content @project2.quadrant_ul
  end

  test "Project owner can edit their project" do
    login_as @user
    visit project_path(@project)
    assert_path project_path(@project)
    page.find('a.edit-project').click
    fill_in 'project[title]', with: "abcxyz"
    fill_in 'project[tag_list]', with: "foo,bar,baz"
    click_on "Save"
    assert_content "Project updated."
    assert_equals "abcxyz", @project.reload.title
    assert_equals ["foo", "bar", "baz"].to_set, @project.tag_list.to_set
  end

  test "Other users can't edit a project" do
    @user2 = create(:user)

    login_as @user2
    visit project_path(@project)
    assert_content(@project.title)
    refute_content "Edit"
    visit edit_project_path(@project)
    assert_content "You don't have permission to edit this project."
    assert_path project_path(@project)
  end
end
