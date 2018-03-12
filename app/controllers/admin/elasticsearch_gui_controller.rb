class Admin::ElasticsearchGuiController < ApplicationController
  http_basic_authenticate_with name: "topher", password: "esgui"

  def page
    @all_indexes = all_indexes
  end

  def query
    begin
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

  def client
    Elasticsearch::Model.client
  end

  def all_indexes
    response = client.perform_request('GET', '_aliases')
    response.as_json['body'].keys.sort
  rescue => e
    []
  end

end
