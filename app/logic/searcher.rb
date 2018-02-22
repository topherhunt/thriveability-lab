class Searcher
  SEARCHABLE_MODELS = [Post, Project, Resource, User]

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
            (@string.present? ? match_string_in_any_field : match_all_documents)
          ]
        }
      },
      from: @from,
      size: @size
    }
  end

  def match_string_in_any_field
    {
      multi_match: {
        query: @string,
        # :fields defaults to all. Don't set fields to ["*"], that's buggy.
        operator: "or", # defaults to "and". "or" is more permissive.
        fuzziness: "AUTO" # (default) allows near-matches.
      }
    }
  end

  def match_all_documents
    {
      match_all: {}
    }
  end
end
