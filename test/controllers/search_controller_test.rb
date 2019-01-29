require "test_helper"

class SearchControllerTest < ActionController::TestCase
  tests SearchController

  context "#search" do
    before do
      @user = create(:user)
      @project = create(:project)
      @resource = create(:resource)
      @convo = create(:conversation)

      @mock_results = stub(
        total: 4,
        loaded_records: [@user, @project, @resource, @convo])
    end

    it "renders correctly when no search was submitted" do
      RunSearch.expects(:call)
        .with(classes: [], string: "", from: 0, size: 10)
        .returns(@mock_results)

      get :search

      assert_response 200
      assert_text "4 results"
      assert_text @project.title
    end

    it "passes all params to the RunSearch service" do
      RunSearch.expects(:call)
        .with(classes: ["User", "Resource"], string: "monkey", from: 40, size: 10)
        .returns(@mock_results)

      get :search, params: {classes: "User,Resource", string: "monkey", page: 5}

      assert_response 200
    end

    it "handles empty result sets" do
      mock_empty_results = stub(total: 0, loaded_records: [])
      RunSearch.stubs(call: mock_empty_results)

      get :search

      assert_response 200
      assert_text "We didn't find any results"
      assert_no_text @project.title
    end
  end
end
