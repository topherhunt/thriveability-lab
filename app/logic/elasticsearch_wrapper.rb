class ElasticsearchWrapper
  class << self
    def rebuild_all_indexes!
      # TODO: Instead, rescue TransportError or whatever
      # unless `ps aux | grep elasticsearch | grep java | grep -v grep`.present?
      #   raise "`elasticsearch` doesn't seem to be running. Start it before running this test."
      # end

      Searcher::SEARCHABLE_MODELS.each do |model|
        model.__elasticsearch__.import(force: true)
      end

      sleep 2 # Give ES time to finish indexing
    end

    def delete_all_indexes!
      all_index_names.each do |index_name|
        response = client.perform_request('DELETE', index_name).as_json
        unless response["body"]["acknowledged"] == true
          raise "Attempt to delete index #{index_name} failed w response: #{response}"
        end
        puts "Deleted index #{index_name}."
      end
    end

    def all_index_names
      response = client.perform_request('GET', '_aliases').as_json
      response["body"].keys.sort
    end

    def client
      Elasticsearch::Model.client
    end
  end
end
