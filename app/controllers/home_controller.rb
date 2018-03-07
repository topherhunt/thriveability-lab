class HomeController < ApplicationController
  def home
    @users = User.most_recent(4).shuffle
    @user_interests = UserData.interests_map(@users)
    # @user_contributions = UserData.contributions_map(@users)
    @projects = Project.most_popular(4).shuffle
    @posts = Post.most_popular(4).shuffle
    @resources = Resource.order("viewings DESC").limit(4).shuffle
    @recent_events = Event.latest(4)
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
