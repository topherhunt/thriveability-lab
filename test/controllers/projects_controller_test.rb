require "test_helper"

# I almost never use controller specs. These are only here so I have an easy
# template to copy from if I need to test some advanced controller logic.

class ProjectsControllerTest < ActionController::TestCase
  tests ProjectsController

  setup do
    @user = create :user
    sign_in @user
  end

  context "#create" do
    it "creates the project"

    it "returns you to the form if validation errors"

    it "notifies followers of this event" do
      @follower = create :user
      StayInformedFlag.where(user: @follower, target: @user).create!
      assert_equals 0, @follower.notifications.count
      post :create, project: attributes_for(:project)
      assert_equals 1, @follower.notifications.count
      n = @follower.notifications.last
      assert_equals @user, n.event.actor
      assert_equals @user.projects.last, n.event.target
    end
  end
end
