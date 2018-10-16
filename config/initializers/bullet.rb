if defined?(Bullet)
  Rails.application.config.after_initialize do
    # See https://github.com/flyerhzm/bullet
    # Throw exception if lazy-loaded queries are detected

    # I tried this out briefly but ended up disabling it for now because it's
    # too demanding; it would require a dramatic rewrite / rethink of the code
    # and the way it's structured. Probably a useful rewrite. But not one I have
    # time for.
    # Plus the error messages it gives aren't as helpful as I would like, because
    # the nature of this gem is that it's constantly fighting against AR's
    # lazy loading capabilities.

    Bullet.enable = false
    Bullet.raise = true
    Bullet.unused_eager_loading_enable = false
  end
end
