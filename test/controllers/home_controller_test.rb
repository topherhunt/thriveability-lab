require "test_helper"

class HomeControllerTest < ActionController::TestCase
  tests HomeController

  context "#home" do
    it "renders the homepage" do
      # Populate some sample content
      create :project, created_at: 5.days.ago
      create :conversation, created_at: 4.days.ago
      resource = create :resource, created_at: 2.days.ago
      create :like_flag, target: resource, created_at: 1.days.ago

      get :home

      assert response.body.include?("Thriveability Lab")
    end
  end

  context "#about" do
    it "renders correctly" do
      get :about
      assert_text "What is Thriveability Lab?"
    end
  end

  context "#principles" do
    it "renders correctly" do
      get :principles
      assert_text "Principles of Thriveability Lab"
    end
  end

  context "#how_you_can_help" do
    it "renders correctly" do
      get :how_you_can_help
      assert_text "How you can help"
    end
  end

  context "#throwup" do
    it "raises an exception for testing" do
      assert_raises(RuntimeError) { get :throwup }
    end
  end
end
