if Rails.env.development?
  begin
    # Verify that Elasticsearch is running and reachable
    ElasticsearchWrapper.new.check_health
  rescue Faraday::ConnectionFailed => e
    msg = "WARNING: Elasticsearch isn't reachable; disabling indexing."
    Rails.logger.warn(msg)
    puts msg
    ENV['ES_INDEXING_DISABLED'] = 'true'
  end
end
