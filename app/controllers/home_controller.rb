class HomeController < ApplicationController
  def home
    @user_thumbnails = User.all.map{ |u| u.image.url(:thumb) }
  end

  def about
    @team = User.where(id: ENV.fetch('TEAM_USER_IDS').split(',')).to_a.shuffle
  end

  def throwup
    raise "Threw up!"
  end
end
