require 'rails_helper'
require 'support/feature_helpers'

describe "Projects" do
  before do
    @user = create(:user)
    @project = create(:project, owner: @user)
  end

  specify "User can create a project" do
    log_in @user
    click_on "Projects"
    click_on "List a project!"
    fill_fields(
      "project[title]": "Gathering Acorns",
      "project[subtitle]": "Re-thinking the way we interface with squirrels",
      "project[introduction]": "Foo bar baz! " * 100,
      "project[location]": "Rio De Janeiro",
      "project[quadrant_ul]": "Vision vision vision",
      "project[quadrant_ur]": "Concrete concrete concrete",
      "project[quadrant_ll]": "Community community community",
      "project[quadrant_lr]": "Framework context framework",
      "project[need_list]": "collaborators, funding, feedback, sponsorship",
      "project[call_to_action]": "Moneys! Moneys!")
    attach_file "project[image]", "#{Rails.root}/public/test/elmerfudd.jpg"
    select "developing", from: "project[stage]"
    click_on "Save"
    @project = Project.last
    current_path.should eq project_path(@project)
    page.should have_content "Your new project is now publicly listed."
    expect_attributes(@project,
      title: "Gathering Acorns",
      subtitle: "Re-thinking the way we interface with squirrels",
      introduction: "Foo bar baz! " * 100,
      location: "Rio De Janeiro",
      quadrant_ul: "Vision vision vision",
      quadrant_ur: "Concrete concrete concrete",
      quadrant_ll: "Community community community",
      quadrant_lr: "Framework context framework",
      need_list: ["collaborators", "funding", "feedback", "sponsorship"],
      call_to_action: "Moneys! Moneys!",
      image_file_name: "elmerfudd.jpg",
      stage: "developing")
  end

  specify "Visitor can browse and view existing projects" do
    @project2 = create(:project, quadrant_ul: "Because it's art")
    @project3 = create(:project)

    visit projects_path
    page.should have_link @project.title
    page.should have_link @project2.title
    page.should have_link @project3.title
    click_on @project2.title
    current_path.should eq project_path(@project2)
    page.should have_content @project2.title
    page.should have_content @project2.quadrant_ul
  end

  specify "Project owner can edit their project" do
    log_in @user
    click_on "Projects"
    click_on @project.title
    current_path.should eq project_path(@project)
    click_on "Edit"
    fill_fields(
      "project[title]": "abcxyz",
      "project[need_list]": "foo,bar,baz")
    click_on "Save"
    page.should have_content "Project updated."
    expect_attributes(@project.reload,
      title: "abcxyz",
      need_list: ["foo", "bar", "baz"])
  end

  specify "Other users can't edit a project" do
    @user2 = create(:user)

    log_in @user2
    visit project_path(@project)
    page.should have_content(@project.title)
    page.should_not have_link "Edit"
    visit edit_project_path(@project)
    page.should have_content "You don't have permission to edit this project."
    current_path.should eq project_path(@project)
  end
end
