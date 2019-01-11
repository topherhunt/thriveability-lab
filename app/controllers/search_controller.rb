class SearchController < ApplicationController
  PER_PAGE = 10
  MAX_PAGE = 100

  def search
    @search_params = {
      classes: (params[:classes] || "").split(","),
      string: (params[:string] || "")
    }
    @results = run_search
    @page = current_page
    @last_page = last_page
  end

  private

  def run_search
    Services::RunSearch.call(
      classes: @search_params[:classes],
      string: @search_params[:string],
      from: ((current_page-1) * PER_PAGE),
      size: PER_PAGE)
  end

  def current_page
    page = params[:page].to_i
    page = 1 if page < 1
    page = MAX_PAGE if page > MAX_PAGE
    page
  end

  def last_page
    last_page = (@results.total * 1.0 / PER_PAGE).ceil
    last_page = MAX_PAGE if last_page > MAX_PAGE
    last_page
  end
end
