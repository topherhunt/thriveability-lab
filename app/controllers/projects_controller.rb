class ProjectsController < ApplicationController
  before_action :require_login, only: [:new, :create, :edit, :update]
  before_action :load_project, only: [:edit, :update, :show]
  before_action :verify_ownership, only: [:edit, :update]

  def index
    @most_popular_projects = Project.most_popular(8)
    @most_recent_activity = RecentEvent.latest_project_activity(5)
    @tag_counts = Project.order("updated_at DESC").limit(100)
      .tag_counts_on(:tags)
      .sort_by(&:name)
  end

  def search
    @projects = Project.all.order("updated_at DESC")
    @filters = params.slice(:tags)
    @projects = @projects.tagged_with(@filters[:tags]) if @filters[:tags].present?
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    @project.owner = current_user

    if @project.save
      NotificationGenerator.new(current_user, :created_project, @project).run
      redirect_to project_path(@project), notice: "Your new project is now publicly listed."
    else
      flash.now.alert = "Unable to save your changes. See error messages below."
      render "new"
    end
  end

  def edit
  end

  def update
    if @project.update(project_params)
      redirect_to project_path(@project), notice: "Project updated."
    else
      flash.now.alert = "Unable to save your changes. See error messages below."
      render "edit"
    end
  end

  def show
  end

  private

  def project_params
    params.require(:project).permit(:title, :subtitle, :introduction, :location, :quadrant_ul, :quadrant_ur, :quadrant_ll, :quadrant_lr, :call_to_action, :stage, :image, :tag_list, :need_list)
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
