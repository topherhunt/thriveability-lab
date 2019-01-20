require "test_helper"

class ResourcesControllerTest < ActionController::TestCase
  tests ResourcesController

  def create_logged_in_user
    user = create :user
    sign_in user
    user
  end

  context "#index" do
    it "renders properly" do
      3.times { create :resource }
      get :index
      assert_equals 200, response.status
    end
  end

  context "#show" do
    it "renders properly" do
      resource = create :resource
      get :show, params: {id: resource.id}
      assert_equals 200, response.status
    end
  end

  context "#new" do
    it "renders properly" do
      @user = create_logged_in_user
      get :new
      assert_equals 200, response.status
    end

    it "requires login" do
      get :new
      assert_redirected_to root_path
    end
  end

  context "#create" do
    it "creates the resource and notifies followers" do
      @user = create_logged_in_user
      @follower = create :user
      StayInformedFlag.where(user: @follower, target: @user).create!
      assert_equals 0, @user.resources.count
      assert_equals 0, @follower.notifications.count

      post :create, params: {resource: attributes_for(:resource)}

      assert_equals 1, @user.resources.count
      assert_redirected_to resource_path(@user.resources.last)
      assert_equals 1, @follower.notifications.count
    end

    it "returns you to the form if validation errors" do
      @user = create_logged_in_user

      post :create, params: {resource: attributes_for(:resource, title: "")}
      assert_equals 0, @user.resources.count
      assert_text "Unable to save your changes"
    end
  end

  context "#edit" do
    it "renders properly" do
      @user = create_logged_in_user
      resource = create :resource, creator: @user
      get :edit, params: {id: resource.id}
      assert_equals 200, response.status
    end

    it "rejects you if you don't have permission" do
      @user = create_logged_in_user
      resource = create :resource
      get :edit, params: {id: resource.id}
      assert_redirected_to resource_path(resource)
    end
  end

  context "#update" do
    it "works"
  end

  context "#destroy" do
    it "works"
  end
end
