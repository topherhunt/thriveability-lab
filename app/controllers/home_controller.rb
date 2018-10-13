class HomeController < ApplicationController
  def home
    @users = User.most_recent(10).shuffle.take(2)
    # @user_interests = UserData.interests_map(@users)
    @projects = Project.most_popular(10).shuffle.take(2)
    @conversations = Conversation.most_popular(10).includes(:participants, :taggings).shuffle.take(2)
    @resources = Resource.order("viewings DESC").limit(10).shuffle.take(2)

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
