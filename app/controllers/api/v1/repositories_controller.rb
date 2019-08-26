class Api::V1::RepositoriesController < ApplicationController
  include SearchableParams

  # GET /api/v1/repositories
  def index
    repositories = Repository
    repositories = Repository.search(search_params) if search_params.present?

    render json: repositories.all
  end

  # GET /api/v1/repositories/1
  def show
    repository = Repository.find(params[:id].to_i)
    render json: repository
  end
end
