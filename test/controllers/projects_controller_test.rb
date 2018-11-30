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
    it "creates the project" do
      post :create, project: attributes_for(:project)
      assert_equals 1, @user.projects.count
      assert_redirected_to project_path(Project.last)
    end

    it "returns you to the form if validation errors"

    it "notifies followers of this event" do
      @user2 = create :user
      StayInformedFlag.where(user: @user2, target: @user).create!

      post :create, project: attributes_for(:project)

      assert_notified @user2, [@user, :create, Project.last]
    end
  end
end
