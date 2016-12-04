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
    assert_equals 0, @user.created_stay_informed_flags.count
    page.find('.stay-informed a').click
    assert_selector '.stay-informed a.active'
    assert_selector '.stay-informed-flags-count'
    assert_equals 1, @user.created_stay_informed_flags.count
    assert_equals @project, @user.created_stay_informed_flags.first.target
    page.find('.stay-informed a').click
    assert_equals 0, @user.created_stay_informed_flags.count
    refute_selector '.stay-informed-flags-count'
    refute_selector '.stay-informed-flags-details' # non-owner can't view details
  end
end
