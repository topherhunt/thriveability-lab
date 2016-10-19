require "test_helper"

class GetInvolvedFlagsTest < Capybara::Rails::TestCase
  setup do
    @owner = create(:user)
    @project = create(:project, owner: @owner)
    @user = create(:user)
  end

  test "User can ask to get involved in a project (and remove that setting)" do
    login_as @user
    visit project_path(@project)
    assert_equals 0, @user.get_involved_flags.count
    page.find('.get-involved a').click
    assert_selector '.get-involved a.active'
    assert_selector '.get-involved-flags-count'
    assert_equals 1, @user.get_involved_flags.count
    assert_equals @project, @user.get_involved_flags.first.target
    page.find('.get-involved a').click
    assert_equals 0, @user.get_involved_flags.count
    refute_selector '.get-involved-flags-count'
    refute_selector '.get-involved-flags-details' # non-owner can't view details
  end

  test "Project owner sees link to details of who wants to stay informed" do
    3.times { @project.get_involved_flags.create!(user: create(:user)) }
    login_as @owner
    visit project_path(@project)
    assert_selector '.get-involved-flags-count', text: '3'
    assert_selector '.get-involved a' # I see the button, but haven't clicked it
    refute_selector '.get-involved a.active'
    page.find('.get-involved-flags-details').click
    assert_path get_involved_flags_path('Project', @project.id)
    assert_selector '.get-involved-users-list a', count: 3
  end
end
