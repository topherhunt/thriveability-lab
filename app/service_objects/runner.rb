class Runner
  def self.delete_old_notifications
    User.find_each do |user|
      cutoff_datetime = user.notifications.order("created_at DESC").limit(50).pluck(:created_at).min
      user.notifications.where("created_at < ?", cutoff_datetime).delete_all
    end
  end
end
