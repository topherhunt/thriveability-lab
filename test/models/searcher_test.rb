require "test_helper"

# These tests serve as a demo of common ES search techniques.
class SearcherTest < ActiveSupport::TestCase

  def debug(records)
    records.map { |r| "#{r.class}: #{r.try(:title) || r.full_name}" }
  end

  describe "running searches" do
    setup do
      @user1 = create :user, first_name: "Mackenzie", last_name: "Platypus"
      @project1 = create :project, title: "Omnivore's Dilemma"
      @resource1 = create :resource, title: "Mackenzie's Study"
      @post1 = create :published_post, title: "Platypus is an Omnivore"
      @post2 = create :published_post, title: "My study of Omnivores"
      @draft = create :draft_post
      @comment = create :published_post, parent: @post2
      Searcher.rebuild_es_index!
    end

    it "searches across all indexed models by default" do
      search1 = Searcher.new(string: "omniVORE").run
      expected1 = [@project1, @post1, @post2]
      assert_equals debug(expected1).sort, debug(search1.records).sort

      search2 = Searcher.new(string: "mackenzie").run
      expected2 = [@user1, @resource1]
      assert_equals debug(expected2).sort, debug(search2.records).sort

      search3 = Searcher.new(string: "Beelzebub").run
      assert_equals 0, search3.records.count
    end

    it "includes all results when query is blank" do
      search_all = Searcher.new(string: "").run
      assert_equals 11, search_all.count
    end

    it "can limit results to specific models" do
      search = Searcher.new(string: "study", models: [Resource]).run
      expected = [@resource1]
      assert_equals debug(expected).sort, debug(search.records).sort
    end

    it "can paginate results" do
      search_all = Searcher.new(string: "").run
      assert_equals 11, search_all.count

      search1 = Searcher.new(string: "", from: 0, size: 10).run
      assert_equals 10, search1.count
      assert_equals debug(search_all.records[0..9]), debug(search1.records)

      search2 = Searcher.new(string: "", from: 10, size: 10).run
      assert_equals 1, search2.count
      assert_equals debug(search_all.records[10..-1]), debug(search2.records)
    end

    it "returns published posts, but not drafts or comments" do
      draft = create :draft_post
      search_posts = Searcher.new(string: "", models: [Post]).run
      expected = [@post1, @post2]
      assert_equals debug(expected).sort, debug(search_posts.records).sort
    end
  end

  it "SEARCHABLE_FIELDS contains a list of all indexed fields" do
    known_fields = Searcher::SEARCHABLE_FIELDS.map { |f| f.sub(/[\^\d\.]+/, "") }
    known_but_ignored = ["visible"]

    [
      create(:user),
      create(:published_post),
      create(:project),
      create(:resource)
    ].each do |record|
      record.as_indexed_json.keys.map(&:to_s).each do |field|
        next if field.in?(known_but_ignored)
        unless field.in?(known_fields)
          raise "#{record.class} indexed field '#{field}' isn't included in Searcher::SEARCHABLE_FIELDS! Fix it or the field will be excluded from ES queries."
        end
      end
    end
  end
end
