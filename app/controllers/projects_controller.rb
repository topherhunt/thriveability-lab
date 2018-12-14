class ProjectsController < ApplicationController
  before_action :require_logged_in, only: [:new, :create, :edit, :update]
  before_action :load_project, only: [:edit, :update, :show]
  before_action :verify_ownership, only: [:edit, :update]

  def index
    @most_popular_projects = Project.most_popular(8)
    @recent_events = Event.where(target_type: "Project").latest(5)
    @tag_counts = Project.order("updated_at DESC").limit(100)
      .tag_counts_on(:tags)
      .sort_by(&:name)
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    @project.owner = current_user

    if @project.save
      Event.register(current_user, "create", @project)
      redirect_to project_path(@project), notice: "Your project was added successfully!"
    else
      flash.now.alert = "Unable to save your changes. See error messages below."
      render "new"
    end
  end

  def edit
  end

  def update
    if @project.update(project_params)
      redirect_to project_path(@project), notice: "Your project was updated successfully."
    else
      flash.now.alert = "Unable to save your changes. See error messages below."
      render "edit"
    end
  end

  def show
  end

  def resources
  end

  private

  def project_params
    params.require(:project).permit(:title, :subtitle, :partners, :video_url, :image, :desired_impact, :contribution_to_world, :location_of_home, :location_of_impact, :stage, :tag_list, :help_needed, :q_background, :q_meaning, :q_community, :q_goals, :q_how_make_impact, :q_how_measure_impact, :q_potential_barriers, :q_project_assets, :q_larger_vision)
  end

  def load_project
    @project = Project.find(params[:id])
  end

  def verify_ownership
    unless @project.owner == current_user
      redirect_to project_path(@project), alert: "You don't have permission to edit this project."
    end
  end

end
