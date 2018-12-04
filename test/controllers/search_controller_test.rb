require "test_helper"

# I almost never use controller specs. These are only here so I have an easy
# template to copy from if I need to test some advanced controller logic.

class SearchControllerTest < ActionController::TestCase
  tests SearchController

  context "#search" do
    def assert_shown(records)
      records.each do |r|
        assert response.body.include?(expected_text(r)),
          "Results should include #{expected_text(r).inspect} (for #{debug(r)}), but I don't see it.\nFull response:\n#{response.body}"
      end
    end

    def assert_not_shown(records)
      records.each do |r|
        assert !response.body.include?(expected_text(r)),
          "Results should NOT include #{expected_text(r).inspect} (for #{debug(r)}), but it's there.\nFull response:\n#{response.body}"
      end
    end

    def expected_text(record)
      record.try(:title) || record.full_name
    end

    def debug(record)
      "#{record.class} #{record.id}"
    end

    # TODO: There's no need to do ElasticSearch indexing here. We should stub out
    # the Searcher module instead.

    it "lists all matching results" do
      user1 = create :user, first_name: "Antelope", last_name: "McCreary"
      project1 = create :project, title: "Apple Antelope"
      resource1 = create :resource, title: "Antelope Cat"
      convo1 = create :conversation, title: "Cat Dog Antelope"; create :comment, context: convo1
      user2 = create :user
      project2 = create :project
      resource2 = create :resource
      convo2 = create :conversation; create :comment, context: convo2
      # TODO: We shouldn't do this. Instead stub out Searcher so the controller
      # doesn't rely on ES running.
      ElasticsearchWrapper.rebuild_all_indexes!

      get :search, query: "antelope"
      assert_shown([user1, project1, resource1, convo1])
      assert_not_shown([user2, project2, resource2, convo2])
    end

    it "can limit results to certain models" do
      user = create :user
      project = create :project
      resource = create :resource
      ElasticsearchWrapper.rebuild_all_indexes!

      get :search, query: "", models: "User,Resource"
      assert_shown([user, resource])
      assert_not_shown([project])
    end

    it "limits to the first 10 results" do
      create_list :user, 26
      ElasticsearchWrapper.rebuild_all_indexes!

      get :search, query: ""
      assert_select "div.test-search-result", count: 10
    end

    it "can return the requested page of results" do
      create_list :user, 16
      ElasticsearchWrapper.rebuild_all_indexes!

      total_num_records = Searcher.new(string: "").run.records.count
      get :search, query: "", page: 2
      assert_select "div.test-search-result", count: 6
    end
  end
end
