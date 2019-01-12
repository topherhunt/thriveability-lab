class RunSearch < BaseService
  def call(classes: [], string:, from: 0, size: 100)
    query = build_query(
      classes: validate_classes(classes), # each must be a string
      string: string,
      from: from,
      size: size)
    @response = ElasticsearchWrapper.new.search(query)
    @total = @response["hits"].fetch("total")
    log :info, "Ran search: #{query.to_json}. #{@total} results."
    self
  end

  #
  # Helpers for inspecting & loading the results
  #

  attr_reader :total, :response

  def identifiers
    @identifiers ||= @response["hits"]["hits"].map do |hit|
      source = hit.fetch("_source")
      [source.fetch("class"), source.fetch("id")]
    end
  end

  # Batch-load each result's record if it exists. NOT memoized.
  # Return them in an array preserving the search result order.
  def loaded_records
    classes = identifiers.map(&:first).uniq.sort
    records = classes.map { |c| c.constantize.find(ids_in_class(c)) }.flatten
    identifiers.map do |(klass, id)|
      records.find { |r| r.class.to_s == klass && r.id == id } # may be nil
    end.compact
  end

  def ids_in_class(target_class)
    identifiers
      .select { |(c, id)| c == target_class }
      .map { |(c, id)| id }
  end

  #
  # Internal helpers
  #

  def validate_classes(classes)
    classes = classes.count >= 1 ? classes : all_searchable_classes
    classes.each do |c|
      unless c.in?(all_searchable_classes)
        raise "Invalid class value #{c.inspect}. Valid values: #{all_searchable_classes}"
      end
    end
    classes
  end

  def all_searchable_classes
    ElasticsearchIndexHelper::SEARCHABLE_CLASSES.map(&:to_s)
  end

  def build_query(classes:, string:, from:, size:)
    {
      query: {
        bool: {
          filter: [{terms: {class: classes}}],
          must: [match_string_if_present(string)]
        }
      },
      sort: [{_score: "desc"}],
      from: from,
      size: size
    }
  end

  def match_string_if_present(string)
    if string.present?
      {
        multi_match: {
          query: string,
          fields: %w(full_text_primary^3 full_text_secondary^1),
          operator: "and",
          fuzziness: "AUTO" # (default) allows near-matches
        }
      }
    else
      {match_all: {}}
    end
  end
end
