class Admin::ElasticsearchGuiController < ApplicationController
  http_basic_authenticate_with name: "topher", password: "esgui"

  def page
    @all_indexes = all_indexes
  end

  def query
    begin
      # results = Elasticsearch::Model.search(params[:query], [Post, Project, Resource, User])
      client = Elasticsearch::Client.new(log: true)
      response = client.search({
        index: params[:indexes],
        body: params[:query]
      })
      results = response.as_json['hits']['hits']
      render json: {
        success: true,
        num_results: results.count,
        results: results.to_json
      }
    rescue => e
      render json: {error: e.to_s}
    end
  end

  private

  def all_indexes
    client = Elasticsearch::Client.new(log: true)
    response = client.perform_request('GET', '_aliases')
    response.as_json['body'].keys.sort
  rescue => e
    []
  end

end
