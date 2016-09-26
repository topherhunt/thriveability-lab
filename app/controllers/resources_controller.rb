class ResourcesController < ApplicationController
  before_action :require_login, only: [:new, :create, :edit, :update]
  before_action :load_resource, only: [:edit, :update, :show]
  before_action :load_target, only: [:new, :create]
  before_action :verify_ownership, only: [:edit, :update]

  def new
    @resource = Resource.new
  end

  def create
    @resource = Resource.new(create_params)
    @resource.creator = current_user

    if @resource.save
      redirect_to return_to_path, notice: "Resource saved successfully."
    else
      flash.now.alert = "Unable to save your changes. See error messages below."
      render "new"
    end
  end

  def edit
    TODO
  end

  def update
    TODO
  end

  def show
  end

  private

  def load_resource
    @resource = Resource.find(params[:id])
  end

  # Main purpose: to verify that the target class & id specify a valid resource.
  def load_target
    if params.dig(:resource, :target_type)
      @target = params[:resource][:target_type].constantize.find(params[:resource][:target_id])
    end
  end

  def create_params
    params.require(:resource).permit(:title, :description, :url, :attachment, :ownership_affirmed, :target_type, :target_id)
  end

  def return_to_path
    if @target
      url_for(@target)
    elsif params[:editing_user_profile].present?
      user_path(current_user)
    else
      resources_path
    end
  end

  def verify_ownership
    unless @resource.creator == current_user
      redirect_to resource_path(@resource), alert: "You don't have permission to edit this resource."
    end
  end

end
