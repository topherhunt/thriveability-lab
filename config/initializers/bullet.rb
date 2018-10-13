if defined?(Bullet)
  Rails.application.config.after_initialize do
    # See https://github.com/flyerhzm/bullet
    # Throw exception if lazy-loaded queries are detected
    Bullet.enable = true
    Bullet.raise = true
  end
end
