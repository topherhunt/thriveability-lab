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
    assert_equals 0, @user.created_get_involved_flags.count
    page.find('.get-involved a').click
    assert_selector '.get-involved a.active'
    assert_selector '.get-involved-flags-count'
    assert_equals 1, @user.created_get_involved_flags.count
    assert_equals @project, @user.created_get_involved_flags.first.target
    page.find('.get-involved a').click
    assert_equals 0, @user.created_get_involved_flags.count
    refute_selector '.get-involved-flags-count'
    refute_selector '.get-involved-flags-details' # non-owner can't view details
  end
end
