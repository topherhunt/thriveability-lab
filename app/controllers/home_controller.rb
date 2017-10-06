class HomeController < ApplicationController
  def home
    @users = User.most_recent(5).shuffle
    @user_interests = UserData.interests_map(@users)
    # @user_contributions = UserData.contributions_map(@users)
    @projects = Project.most_popular(5).shuffle
    @posts = Post.most_popular(5).shuffle
    @resources = Resource.order("viewings DESC").limit(5).shuffle
    @recent_events = Event.latest(5)
    render "home/home.haml", layout: "home"
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
