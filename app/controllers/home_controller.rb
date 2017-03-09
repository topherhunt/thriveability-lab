class HomeController < ApplicationController
  def home
    @featured_users = User.most_recent(15)
    @featured_projects = Project.most_popular(6)
    @featured_posts = Post.most_popular
    @recent_events = RecentEvent.latest(5)
    @users_count = User.count
    @projects_count = Project.count
    @posts_count = Post.published.roots.count
    @resources_count = Resource.count
    render "home/home", layout: "home"
  end

  def about
    @team = User.where(id: ENV.fetch('TEAM_USER_IDS').split(',')).to_a.shuffle
  end

  def throwup
    raise "Threw up!"
  end
end
