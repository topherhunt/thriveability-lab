# ElasticSearch indexing layer. Knows everything about what models should be indexed.
class ElasticsearchIndexHelper
  SEARCHABLE_CLASSES = [User, Project, Conversation, Resource]

  def delete_and_rebuild_index!
    wrapper.delete_index
    wrapper.create_index
    num_indexed = 0
    SEARCHABLE_CLASSES.each do |klass|
      # NOTE: If I need to do large-scale full reindexing often, consider
      # setting up batch-import to reduce the # of ES calls used.
      # (see elasticsearch-rails .import(force: true), it did this well)
      klass.all.find_each { |r| create_document(r); num_indexed += 1 }
    end
    verify_new_documents_ingested(num_indexed)
  end

  def verify_new_documents_ingested(num_to_expect)
    waited = 0
    while wrapper.count_documents < num_to_expect
      sleep 0.1
      waited += 0.1
      raise "Waited too long for indexed docs to be digested!" if waited >= 5
    end
  end

  def create_document(record)
    wrapper.index_document!(document_id(record), document_body(record))
  end

  def update_document(record)
    wrapper.index_document!(document_id(record), document_body(record))
  end

  def delete_document(record)
    wrapper.delete_document(document_id(record))
  end

  private

  def wrapper
    @wrapper ||= ElasticsearchWrapper.new
  end

  def document_id(record)
    "#{record.class.to_s}:#{record.id}"
  end

  def document_body(record)
    {class: record.class.to_s, id: record.id}.merge(record.to_elasticsearch_document)
  end

  def log(sev, message)
    sev.in?([:info, :warn, :error]) || raise("Unknown severity '#{sev}'!")
    Rails.logger.send(sev, "#{self.class}: #{message}")
  end
end
