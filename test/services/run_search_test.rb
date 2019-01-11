require "test_helper"

class Services::RunSearchTest < ActiveSupport::TestCase
  def assert_results_equal(result, expected)
    # First compare the identifiers
    assert_equals(
      Set.new(expected.map { |e| [e.class.to_s, e.id] }),
      Set.new(result.identifiers))
    # Then also check loaded_records, just as a sanity check
    assert_equals(
      Set.new(expected),
      Set.new(result.loaded_records))
  end

  test "elasticsearch integration works w all kinds of searches" do
    # These tests are grouped into one example to minimize ES reindexing time.
    @user1 = create :user, name: "A person who likes apple pie"
    @project1 = create :project, title: "Apple farming in urban parks"
    @project2 = create :project, title: "Another, irrelevant project"
    @resource1 = create :resource, title: "A resource about apples"
    @resource2 = create :resource, title: "A second, irrelevant resource"
    @convo1 = create :conversation, title: "This conversation is about apples"
    @convo2 = create :conversation, title: "A second conversation"
    @convo3 = create :conversation, title: "A third, irrelevant conversation"
    create :comment, context: @convo2, body: "Apples are important to this comment"

    assert_elasticsearch_running
    ElasticsearchIndexHelper.new.delete_and_rebuild_index!

    # a broad search returning all kinds of content
    result = Services::RunSearch.call(string: "apple")
    assert_equals 5, result.total
    assert_results_equal(result, [@user1, @project1, @resource1, @convo1, @convo2])

    # a blank search (match all)
    result = Services::RunSearch.call(string: "")
    assert_equals 16, result.total

    # a search with no results
    result = Services::RunSearch.call(string: "gobbledygook")
    assert_equals 0, result.total
    assert_equals [], result.loaded_records

    # a paginated search
    all_results = Services::RunSearch.call(string: "").identifiers
    page3_results = Services::RunSearch.call(string: "", from: 6, size: 3)
    assert_equals 16, page3_results.total
    assert_equals 3, page3_results.identifiers.count
    assert_equals all_results[6..8], page3_results.identifiers

    # a search that limits based on result type
    result = Services::RunSearch.call(string: "", classes: ["Project", "Resource"])
    assert_equals 4, result.total
    expected = [@project1, @project2, @resource1, @resource2]
    assert_results_equal result, [@project1, @project2, @resource1, @resource2]
  end
end
