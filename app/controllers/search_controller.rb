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
      models: models_to_search.map(&:to_s)
    }
  end

  private

  def query
    params[:query] || ""
  end

  def models_to_search
    searchable_model_names = Searcher::SEARCHABLE_MODELS.map(&:to_s)
    param_as_array(params[:models])
      .select { |name| name.in?(searchable_model_names) }
      .map(&:constantize)
  end

  def param_as_array(param)
    if param.is_a?(Array)
      param
    elsif param.is_a?(String)
      param.split(",")
    else
      []
    end
  end

  def page
    page = (params[:page] || 1).to_i
    page >= 1 ? page : 1
  end

end
