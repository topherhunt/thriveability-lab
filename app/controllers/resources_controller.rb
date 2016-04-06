class ResourcesController < ApplicationController

  def new
    @resource = Resource.new(creator: current_user)
  end

  def create
    @resource = Resource.new(resource_params)
    @resource.creator = current_user

    if @resource.save
      # TODO: hinge on params[:editing_user_profile]
      redirect_to true ? user_path(current_user) : resources_path, notice: "Resource saved successfully."
    else
      flash.now.alert = "Unable to save your changes. See error messages below."
      render "new"
    end
  end

  def show
    @resource = Resource.find(params[:id])
  end

  private

  def resource_params
    params.require(:resource).permit(:title, :description, :url, :attachment, :ownership_affirmed)
  end

end
