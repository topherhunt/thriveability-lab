class HomeController < ApplicationController
  skip_before_action :load_current_user, only: [:ping, :throwup, :missing_route]

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

  def principles
    render "home/principles.haml", layout: "application" # (default is "home")
  end

  def how_you_can_help
    render "home/how_you_can_help.haml", layout: "application" # (default is "home")
  end

  #
  # Utility routes, not user-facing
  # TODO: These belong in a separate controller
  #

  def ping
    render json: {ok: true}, status: 200
  end

  def throwup
    raise "Threw up!"
  end

  def missing_route
    log :error, "Routing error: Route #{request.original_url} does not exist. "\
      "Useragent: #{request.user_agent.inspect}"
    render file: "public/404.html", layout: false, status: 404
  end
end
