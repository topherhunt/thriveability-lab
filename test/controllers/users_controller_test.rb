require "test_helper"

class UsersControllerTest < ActionController::TestCase
  tests UsersController

  context "#index" do
    it "works" do
      3.times { create :user }
      get :index
      assert_response 200
    end
  end

  context "#show" do
    it "renders the user profile correctly" do
      user = create :user
      # Populate some sample content
      create :project, owner: user
      create :conversation, creator: user
      create :resource, creator: user

      get :show, id: user.id
      assert_text user.name
    end
  end

  context "#edit" do
    setup do
      @user = create :user
    end

    it "renders the edit form if logged in" do
      sign_in @user
      get :edit, id: @user.id
      assert_text "Update my profile"
    end

    it "rejects if you aren't logged in" do
      get :edit, id: @user.id
      assert_redirected_to root_path
    end
  end

  context "#update" do
    setup do
      @user = create :user
    end

    it "updates the user" do
      sign_in @user
      patch :update, id: @user.id, user: {name: "Daffy"}

      assert_equals "Daffy", @user.reload.name
      assert_redirected_to user_path(@user)
    end

    it "rejects if the logged-in user is not the target user" do
      user2 = create :user
      sign_in user2
      orig_user1_name = @user.name
      orig_user2_name = user2.name

      patch :update, id: @user.id, user: {name: "Daffy"}

      assert_redirected_to root_path
      assert_equals orig_user1_name, @user.reload.name
      assert_equals orig_user2_name, user2.reload.name
    end

    it "rejects if invalid params" do
      sign_in @user
      original_name = @user.name
      patch :update, id: @user.id, user: {name: "too long  "*100}

      assert_equals original_name, @user.reload.name
      assert_text "Unable to save your changes."
    end

    it "rejects if not logged in" do
      patch :update, id: @user.id, user: {name: "Daffy"}

      assert_redirected_to root_path
    end
  end
end
