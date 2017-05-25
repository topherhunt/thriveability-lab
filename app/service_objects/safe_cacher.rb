module SafeCacher
  extend self

  # Use the standard Rails cache... unless tests are enabled.
  def cache(key, opts, &block)
    if Rails.env.test?
      yield block
    else
      Rails.cache.fetch(key, opts, &block)
    end
  end
end
