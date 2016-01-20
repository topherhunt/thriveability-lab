class HomeController < ApplicationController
  def home
  end

  def about
  end

  def throwup
    raise "Threw up!"
  end
end
