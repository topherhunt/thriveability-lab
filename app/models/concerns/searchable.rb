module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model

    # Only give each index 1 shard so we don't exceed Bonsai limit of 10 shards
    __elasticsearch__.settings(index: {number_of_shards: 1})

    __elasticsearch__.index_name "thrivability-#{Rails.env}-#{self.to_s.downcase.pluralize}"

    after_create :create_es_document
    after_update :update_es_document
    after_destroy :delete_es_document

    def create_es_document
      return if es_disabled?
      __elasticsearch__.index_document
      Rails.logger.info "Created ES index for #{self.class} #{self.id}."
    end

    def update_es_document
      return if es_disabled?
      # TODO: It would be nice to skip update if we know that no indexed fields
      # have changed, e.g. each time a User logs in.
      __elasticsearch__.index_document
      Rails.logger.info "Updated ES index for #{self.class} #{self.id}."
    end

    def delete_es_document
      return if es_disabled?
      __elasticsearch__.delete_document
      Rails.logger.info "Deleted ES index for #{self.class} #{self.id}."
    end

    def es_disabled?
      Rails.env.test? || ENV['ES_INDEXING_DISABLED'] == 'true'
    end

    def as_indexed_json(opts={})
      es_index_json(opts)
    end

    # Each model must implement this method.
    def es_index_json(opts={})
      raise "#{self.class} must implement #es_index_json"
    end
  end

end
