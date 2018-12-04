class Searcher
  SEARCHABLE_MODELS = [User, Project, Conversation, Resource]
  SEARCHABLE_FIELDS = %w(full_name^3 title^3 tagline^1.5 subtitle^1.5 interests description location bio_interior bio_exterior current_url source_name tags media_types published_content author_name owner creator comments^0.5 stage partners desired_impact contribution_to_world location_of_home location_of_impact help_needed q_background q_meaning q_community q_goals q_how_make_impact q_how_measure_impact q_potential_barriers q_project_assets q_larger_vision)

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
