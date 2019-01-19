class HomeController < ApplicationController
  def home
    @users = User.most_recent(10).shuffle.take(2)
    # @user_interests = UserData.interests_map(@users)
    @projects = Project.includes(:taggings).most_popular(10).shuffle.take(2)
    @conversations = Conversation.most_popular(10).includes(:participants, :taggings).shuffle.take(2)
    @resources = Resource.includes(:taggings).order("viewings DESC").limit(10).shuffle.take(2)

    render "home/home.haml", layout: "home"
  end

  def about
    @team = User.where(email: ENV.fetch('TEAM_USER_EMAILS').split(',')).to_a.shuffle
    render "home/about.haml", layout: "application" # (default is "home")
  end

  def guiding_principles
    render "home/guiding_principles.haml", layout: "application" # (default is "home")
  end

  def how_you_can_help
    render "home/how_you_can_help.haml", layout: "application" # (default is "home")
  end

  def throwup
    raise "Threw up!"
  end

  def ping
    render json: {ok: true}, status: 200
  end
end
