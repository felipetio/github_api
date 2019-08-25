class Api::V1::RepositoriesController < ApplicationController

  # GET /api/v1/repositories
  def index
    repositories = Repository.all

    render json: repositories
  end

  # GET /api/v1/repositories/1
  def show
    repository = Repository.find(params[:id].to_i)
    render json: repository
  end

  private
    # Only allow a trusted parameter "white list" through.
    def repository_params
      params.fetch(:repository, {})
    end
end
