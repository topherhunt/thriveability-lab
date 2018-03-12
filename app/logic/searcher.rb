class Searcher
  SEARCHABLE_MODELS = [User, Project, Post, Resource]
  SEARCHABLE_FIELDS = ["full_name^3", "title^3", "tagline^1.5", "subtitle^1.5", "interests", "description", "location", "bio_interior", "bio_exterior", "current_url", "source_name", "tags", "media_types", "published_content", "author_name", "owner", "descendants^0.5", "introduction", "stage"]

  def self.rebuild_es_index!
    unless `ps aux | grep elasticsearch | grep java | grep -v grep`.present?
      raise "`elasticsearch` doesn't seem to be running. Start it before running this test."
    end

    SEARCHABLE_MODELS.each { |model| model.__elasticsearch__.import(force: true) }
    sleep 2 # Give ES time to finish indexing
  end

  def initialize(string:, models: nil, from: 0, size: 100)
    @string = string
    @models = models || SEARCHABLE_MODELS
    @from = from
    @size = size
  end

  def run
    Rails.logger.info "ElasticSearch query against #{@models.map(&:to_s)}: #{query.to_json}"
    Elasticsearch::Model.search(query, @models)
  end

  def query
    {
      query: {
        bool: {
          filter: [
            {term: {visible: true}}
          ],
          must: [
            (@string.present? ? match_string : match_all_documents)
          ]
        }
      },
      from: @from,
      size: @size
    }
  end

  def match_string
    {
      multi_match: {
        query: @string,
        fields: SEARCHABLE_FIELDS,
        operator: "and",
        fuzziness: "AUTO" # (default) allows near-matches
      }
    }
  end

  def match_all_documents
    {
      match_all: {}
    }
  end
end
