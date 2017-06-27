require 'rails_helper'

# I almost never use controller specs. These are only here so I have an easy
# template to copy from if I need to test some advanced controller logic.

class PostControllerTest < ActionController::TestCase do
  tests PostController

  context "#create" do
    pending "TODO: Test each controller path and verify correct results"
  end

  context "#throwup" do
    it "raises an exception for testing" do
      assert_raises(RuntimeError) { get :throwup }
    end
  end
end
