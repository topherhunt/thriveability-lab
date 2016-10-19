require "test_helper"

class StayInformedFlagsTest < Capybara::Rails::TestCase
  setup do
    @owner = create(:user)
    @project = create(:project, owner: @owner)
    @user = create(:user)
  end

  test "User can ask to stay informed on a project (and remove that setting)" do
    login_as @user
    visit project_path(@project)
    assert_equals 0, @user.stay_informed_flags.count
    page.find('.stay-informed a').click
    assert_selector '.stay-informed a.active'
    assert_selector '.stay-informed-flags-count'
    assert_equals 1, @user.stay_informed_flags.count
    assert_equals @project, @user.stay_informed_flags.first.target
    page.find('.stay-informed a').click
    assert_equals 0, @user.stay_informed_flags.count
    refute_selector '.stay-informed-flags-count'
    refute_selector '.stay-informed-flags-details' # non-owner can't view details
  end

  test "Project owner sees link to details of who wants to stay informed" do
    3.times { @project.stay_informed_flags.create!(user: create(:user)) }
    login_as @owner
    visit project_path(@project)
    assert_selector '.stay-informed-flags-count', text: '3'
    assert_selector '.stay-informed a' # I see the button, but haven't clicked it
    refute_selector '.stay-informed a.active'
    page.find('.stay-informed-flags-details').click
    assert_path stay_informed_flags_path('Project', @project.id)
    assert_selector '.stay-informed-users-list a', count: 3
  end
end
