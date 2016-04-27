class HomeController < ApplicationController
  def home
    @user_thumbnails = User.all.map{ |u| u.image.url(:thumb) }
  end

  def about
  end

  def throwup
    raise "Threw up!"
  end
end
