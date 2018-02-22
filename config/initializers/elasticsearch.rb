# In production, use the config provided by bonsai-elasticsearch-rails.
unless Rails.env.production?
  Elasticsearch::Model.client = Elasticsearch::Client.new(
    host: "http://localhost:9200",
    transport_options: {
      request: {timeout: 5}
    }
  )
end
