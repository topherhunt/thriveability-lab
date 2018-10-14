require "test_helper"

# I almost never use controller specs. These are only here so I have an easy
# template to copy from if I need to test some advanced controller logic.

class HomeControllerTest < ActionController::TestCase
  tests HomeController

  context "#home" do
    it "renders the homepage" do
      get :home
      assert response.body.include?("Thrivability Lab")
    end
  end

  context "#throwup" do
    it "raises an exception for testing" do
      assert_raises(RuntimeError) { get :throwup }
    end
  end
end
