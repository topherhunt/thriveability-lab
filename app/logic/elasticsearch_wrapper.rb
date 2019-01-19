# ElasticSearch low-level wrapper. Knows about our global index and field mappings,
# but doesn't know anything about ActiveRecord, what models are indexed, how to
# search, etc.
#
# Other ops useful for debugging:
# - List all indexes: run(:get, "_aliases").keys
#
class ElasticsearchWrapper
  def check_health
    client.cluster.health # If no exceptions, that means it's connected
  end

  # See https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html
  def create_index
    run(:put, index_name, body: {
      # Start with 1 shard, and add more as content grows.
      # See https://www.elastic.co/blog/how-many-shards-should-i-have-in-my-elasticsearch-cluster
      settings: {index: {number_of_shards: 1}},
      # See https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping.html
      mappings: {
        doc: { # Use 'doc' as our sole mapping type (a soon-to-be-deprecated concept)
          dynamic: "strict", # Disable dynamic mapping (it's on by default)
          properties: standard_field_mappings
        }
      }
    })
    log :info, "Created index #{index_name}"
  end

  def delete_index
    if index_exists?
      run(:delete, index_name)
      log :info, "Deleted index #{index_name}"
    else
      log :info, "Index #{index_name} not found, so not deleted."
    end
  end

  def list_indexes
    run(:get, "_aliases").keys
  end

  def index_exists?
    list_indexes.include?(index_name)
  end

  def index_document!(id, body) # The id can be any arbitrary string
    run(:put, "#{index_name}/doc/#{id}", body: body)
    log :info, "Indexed document #{id}"
  end

  def delete_document(id)
    if run(:delete, "#{index_name}/doc/#{id}", allow_404: true)
      log :info, "Deleted document #{id}"
    else
      log :warn, "Unable to delete document #{id}, got a 404 error"
    end
  end

  def count_documents
    run(:get, "#{index_name}/_count").fetch("count")
  end

  def search(body)
    run(:get, "#{index_name}/_search", body: body)
  end

  #
  # Internal
  #

  def index_name
    @index_name ||= "thriveability-#{Rails.env}-global"
  end

  def standard_field_mappings
    {
      class: {type: "keyword"},
      id: {type: "integer"},
      full_text_primary: {type: "text"}, # for boosted text, e.g. title & tags
      full_text_secondary: {type: "text"} # for unboosted text, e.g. description
      # For now I only set up fields for plain full-text search (one boosted
      # field & one unboosted), but we can also add structured fields, e.g.:
      # - limit results to those having a tag (keyword multivalue field)
      # - filter results by region / proximity (geo point)
    }
  end

  def run(method, path, body: {}, allow_404: false)
    method = method.to_s.upcase
    response = client.perform_request(method, path, {}, body).body.as_json
    # log :debug, "REQUEST: #{method} #{path} #{body.to_json}. RESPONSE: #{response.to_json}"
    response
  rescue => e
    if allow_404 && e.to_s.include?("[404]")
      false
    else
      raise "ElasticsearchWrapper#run failed on #{method} #{path} "\
        "(body: #{body.to_json}). ERROR: #{e}."
    end
  end

  def client
    @client ||= Elasticsearch::Client.new(
      url: ENV.fetch('ELASTICSEARCH_URL'),
      # log: true, # Might be useful when debugging
      # I think this was a development-friendly option, I'll try skipping it
      # transport_options: {request: {timeout: 5}}
    )
  end

  def log(sev, message)
    sev.in?([:info, :warn, :error]) || raise("Unknown severity '#{sev}'!")
    Rails.logger.send(sev, "#{self.class}: #{message}")
  end
end
