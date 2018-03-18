class SearchController < ApplicationController

  PER_PAGE = 10
  MAX_PAGE = 100

  def search
    @search = Searcher.new(
      string: query,
      models: models_to_search,
      from: ((page-1) * PER_PAGE),
      size: PER_PAGE
    ).run
    @search_params = {
      query: params[:query],
      models: models_to_search.map(&:to_s)
    }
    @page = page
    @last_page = last_page
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
    page = params[:page].to_i
    page = 1 if page < 1
    page = MAX_PAGE if page > MAX_PAGE
    page
  end

  def last_page
    last_page = (@search.results.total * 1.0 / PER_PAGE).ceil
    last_page = MAX_PAGE if last_page > MAX_PAGE
    last_page
  end

end
