require "test_helper"

class GetInvolvedFlagsTest < Capybara::Rails::TestCase
  setup do
    @owner = create(:user)
    @project = create(:project, owner: @owner)
    @user = create(:user)
  end

  it "User can ask to get involved in a project and remove that setting" do
    sign_in @user
    visit project_path(@project)
    assert_equals 0, @user.created_get_involved_flags.count
    page.find('.get-involved a').click
    assert_selector '.get-involved a.active'
    assert_equals 1, @user.created_get_involved_flags.count
    assert_equals @project, @user.created_get_involved_flags.first.target
    page.find('.get-involved a').click
    assert_equals 0, @user.created_get_involved_flags.count
  end
end
