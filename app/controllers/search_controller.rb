class SearchController < ApplicationController

  def search
    @search = Searcher.new(
      string: query,
      models: models_to_search,
      from: ((page-1) * 20),
      size: 20
    ).run
    @search_params = {
      query: params[:query],
      models: models_to_search
    }
  end

  private

  def query
    params[:query] || ""
  end

  def models_to_search
    searchable_model_names = Searcher::SEARCHABLE_MODELS.map(&:to_s)
    params[:models].to_s.split(",")
      .select { |name| name.in?(searchable_model_names) }
      .map(&:constantize)
  end

  def page
    page = (params[:page] || 1).to_i
    page >= 1 ? page : 1
  end

end
