# Include this in any model to include it in Elasticsearch indexing & search.
# The model must also implement #to_elasticsearch_document to return a hash
# like {full_text_primary: "The title etc."}
module Searchable
  extend ActiveSupport::Concern

  included do
    after_create :create_es_document
    after_update :update_es_document
    after_destroy :delete_es_document

    def create_es_document
      return if es_autoindexing_disabled?
      ElasticsearchIndexHelper.new.create_document(self)
    end

    def update_es_document
      return if es_autoindexing_disabled?
      # TODO: Skip update if no indexed fields are changed
      ElasticsearchIndexHelper.new.update_document(self)
    end

    def delete_es_document
      return if es_autoindexing_disabled?
      ElasticsearchIndexHelper.new.delete_document(self)
    end

    def es_autoindexing_disabled?
      ENV['ES_INDEXING_DISABLED'] == 'true'
    end

    def to_elasticsearch_document
      raise "#{self.class} must implement #to_elasticsearch_document!"
    end
  end
end
