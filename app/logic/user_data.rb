class UserData
  class << self
    def contributions_map(users)
      users.reduce({}) { |hash, user| hash[user.id] = load_contributions(user); hash }
    end

    def interests_map(users)
      users.reduce({}) { |hash, user| hash[user.id] = load_interests(user); hash }
    end

    def load_contributions(user)
      SafeCacher.cache("user_#{user.id}_recent_contributions") do
        Event
          .where(actor: user, action: [:create, :publish])
          .includes([:actor, :target])
          .latest(5)
          .all
      end
    end

    def load_interests(user)
      SafeCacher.cache("user_#{user.id}_interests") do
        tagged_objects = Event.where(actor: user).pluck(:target_type, :target_id)
        where_sql = taggings_where_sql(tagged_objects)
        tag_ids = ActsAsTaggableOn::Tagging.where(where_sql).pluck(:tag_id)
        # TODO: Order tags by how many events are linked to each tag.
        # This probably requires custom SQL.
        ActsAsTaggableOn::Tag.where(id: tag_ids.uniq).limit(5)
      end
    end

    def taggings_where_sql(tagged_objects)
      pairs = tagged_objects
        .map { |array| "(#{sanitize(array.first)}, #{sanitize(array.last)})" }
        .join(", ")
      if pairs.present?
        "(taggable_type, taggable_id) IN (#{pairs})"
      else
        "1=0" # this makes the where clause exclude everything
      end
    end

    def sanitize(value)
      ActiveRecord::Base.sanitize(value)
    end
  end
end
