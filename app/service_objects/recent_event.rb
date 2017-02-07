# Abstract class to wrap logic for aggregating
class RecentEvent
  def self.latest(limit)
    [
      latest_created_projects(limit),
      latest_created_resources(limit),
      latest_published_posts(limit),
      latest_published_post_comments(limit),
      latest_liked_objects(limit)
    ].flatten
     .sort_by{ |e| 0 - (e.datetime.to_i) }
     .take(limit)
  end

  def self.latest_created_projects(limit)
    Project.all.order("created_at DESC").limit(limit).includes(:owner)
      .map { |p| self.new(p.created_at, p.owner, :created_project, p) }
  end

  def self.latest_created_resources(limit)
    Resource.all.order("created_at DESC").limit(limit).includes(:creator)
      .map { |r| self.new(r.created_at, r.creator, :created_resource, r) }
  end

  def self.latest_published_posts(limit)
    Post.published.roots.order("published_at DESC").limit(limit).includes(:author)
      .map { |p| self.new(p.created_at, p.author, :published_post, p) }
  end

  def self.latest_published_post_comments(limit)
    Post.published.not_roots.order("published_at DESC").limit(limit).includes(:author)
      .map { |p| self.new(p.created_at, p.author, :commented_on_post, p.root) }
  end

  def self.latest_liked_objects(limit)
    LikeFlag.order("created_at DESC").limit(limit).includes(:user, :target)
      .map{ |lf| self.new(lf.created_at, lf.user, :liked_object, lf.target) }
  end

  def initialize(datetime, user, action, target)
    @user = user
    @datetime = datetime
    @action = action
    @target = target
  end

  attr_accessor :user, :datetime, :action, :target

  def action_description
    case action
    when :created_project   then "listed the project"
    when :created_resource  then "added the resource"
    when :published_post    then "started the new conversation"
    when :commented_on_post then "commented on the conversation"
    when :liked_object      then "was inspired by"
    else raise "Unexpected action type :#{action}!"
    end
  end

  def target_description
    target.try(:title) || target.try(:full_name)
  end
end
