class ResourcesController < ApplicationController
  before_action :require_login, only: [:new, :create, :edit, :update, :destroy]
  before_action :load_resource, only: [:show, :edit, :update, :destroy]
  before_action :load_target, only: [:new, :create]
  before_action :verify_ownership, only: [:edit, :update, :destroy]

  def index
    @resources = Resource.all.order("title").includes(:creator, :target)
    @filters = params.slice(:tags, :media_types)
    @resources = @resources.tagged_with(@filters[:tags]) if @filters[:tags].present?
    @resources = @resources.tagged_with(@filters[:media_types]) if @filters[:media_types].present?
  end

  def show
  end

  def new
    @resource = Resource.new
  end

  def create
    @resource = Resource.new(create_params)
    @resource.creator = current_user

    if @resource.save
      NotificationGenerator.new(current_user, :created_resource, @resource).run
      redirect_to return_to_path, notice: "Your changes have been saved."
    else
      flash.now.alert = "Unable to save your changes. See error messages below."
      render "new"
    end
  end

  def edit
  end

  def update
    if @resource.update(update_params)
      redirect_to return_to_path, notice: "Your changes have been saved."
    else
      flash.now.alert = "Unable to save your changes. See error messages below."
      render "edit"
    end
  end

  def destroy
    @resource.destroy!
    redirect_to return_to_path, notice: "The resource was deleted."
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
    params.require(:resource).permit(:title, :description, :url, :attachment, :ownership_affirmed, :target_type, :target_id, :tag_list, :media_type_list)
  end

  def update_params
    params.require(:resource).permit(:title, :description, :url, :attachment, :ownership_affirmed, :tag_list, :media_type_list)
  end

  def return_to_path
    if @resource.target
      url_for(@resource.target)
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
