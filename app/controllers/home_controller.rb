class HomeController < ApplicationController
  def home
    @featured_users = User.most_recent
    @featured_projects = Project.most_popular
    @featured_resources = Resource.most_popular
    @featured_posts = Post.most_popular
    @recent_events = RecentEvent.latest(5)
  end

  def about
    @team = User.where(id: ENV.fetch('TEAM_USER_IDS').split(',')).to_a.shuffle
  end

  def throwup
    raise "Threw up!"
  end
end
