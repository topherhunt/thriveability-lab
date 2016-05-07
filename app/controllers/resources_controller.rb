class ResourcesController < ApplicationController
  before_action :require_login, only: [:new, :create, :edit, :update]
  before_action :load_resource, only: [:edit, :update, :show]
  before_action :verify_ownership, only: [:edit, :update]

  def new
    @resource = Resource.new
  end

  def create
    @resource = Resource.new(resource_params)
    @resource.creator = current_user

    if @resource.save
      flash.notice = "Resource saved successfully."
      redirect_to(params[:editing_user_profile].present? ? user_path(current_user) : resources_path)
    else
      flash.now.alert = "Unable to save your changes. See error messages below."
      render "new"
    end
  end

  def edit
  end

  def update
  end

  def show
  end

  private

  def resource_params
    params.require(:resource).permit(:title, :description, :url, :attachment, :ownership_affirmed)
  end

  def load_resource
    @resource = Resource.find(params[:id])
  end

  def verify_ownership
    unless @resource.creator == current_user
      redirect_to resource_path(@resource), alert: "You don't have permission to edit this resource."
    end
  end

end
