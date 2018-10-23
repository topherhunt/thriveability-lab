# In production, use the config provided by bonsai-elasticsearch-rails.
unless Rails.env.production?
  Elasticsearch::Model.client = Elasticsearch::Client.new(
    host: "http://localhost:9200",
    transport_options: {
      request: {timeout: 5}
    }
  )

  # Test that the ES server is running; disable indexing if it isn't
  begin
    Elasticsearch::Model.client.cluster.health
  rescue Faraday::ConnectionFailed => e
    msg = "WARNING: Can't access the ES server; disabling ES indexing for this session."
    Rails.logger.warn(msg)
    puts msg
    ENV['ES_INDEXING_DISABLED'] = 'true'
  end
end
