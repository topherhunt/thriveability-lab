require "test_helper"

# I almost never use controller specs. These are only here so I have an easy
# template to copy from if I need to test some advanced controller logic.

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

      assert response.body.include?("Thrivability Lab")
    end
  end

  context "#about" do
    it "renders correctly" do
      get :about
      assert_content "What is Thriveability Lab?"
    end
  end

  context "#guiding_principles" do
    it "renders correctly" do
      get :guiding_principles
      assert_content "Principles of Thriveability Lab"
    end
  end

  context "#how_you_can_help" do
    it "renders correctly" do
      get :how_you_can_help
      assert_content "How you can help the Thrivability project"
    end
  end

  context "#throwup" do
    it "raises an exception for testing" do
      assert_raises(RuntimeError) { get :throwup }
    end
  end
end
