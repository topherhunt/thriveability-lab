class HomeController < ApplicationController
  def home
    @featured_users = User.most_recent(15)
    @featured_projects = Project.most_popular(15)
    @featured_posts = Post.most_popular(5)
    @featured_resources = Resource.order("viewings DESC").limit(5)
    @recent_events = RecentEvent.latest(5)
    @users_count = User.count
    @projects_count = Project.count
    @posts_count = Post.published.roots.count
    @resources_count = Resource.count
    render "home/home", layout: "home"
  end

  def about
    @team = User.where(email: ENV.fetch('TEAM_USER_EMAILS').split(',')).to_a.shuffle
  end

  def throwup
    raise "Threw up!"
  end

  def ping
    render text: "OK", status: 200
  end
end
