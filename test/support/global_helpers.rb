class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods
  ActiveRecord::Migration.check_pending!

  # Make all database transactions use the same thread
  ActiveRecord::ConnectionAdapters::ConnectionPool.class_eval do
    def current_connection_id
      Thread.main.object_id
    end
  end

  def emails
    ActionMailer::Base.deliveries
  end

  # The ending 's' makes it a tiny bit more readable
  def assert_equals(*args)
    assert_equal(*args)
  end

  def assert_email_contains(needle, email)
    haystack_text = Nokogiri::HTML(email.html_part.to_s).text
      .encode('ASCII', undef: :replace, replace: '')
      .gsub(/\s+/, ' ')
    assert_includes(haystack_text, needle)
  end

  def assert_elasticsearch_running
    ElasticsearchWrapper.new.check_health
  rescue Faraday::ConnectionFailed
    raise "It looks like elasticsearch isn't available. Is it running?"
  end
end
