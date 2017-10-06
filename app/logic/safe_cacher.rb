module SafeCacher
  class << self
    # Example:
    # SafeCacher.cache("user_#{user_id}_entry_#{id}_sum", expires_in: 5.minutes) do
    #   ...
    # end
    def cache(key, opts = {}, &block)
      if Rails.env.test?
        yield
      else
        Rails.cache.fetch(key, opts) do
          Rails.logger.info "Cacher: Generating cache for key \"#{key}\"."
          yield
        end
      end
    end

    # Example:
    # SafeCacher.delete_matched("user_#{user_id}_")
    def delete_matched(pattern)
      Rails.logger.info "Cacher: Deleting entries matching pattern \"#{pattern}\"."
      Rails.cache.delete_matched(pattern)
    end
  end
end
