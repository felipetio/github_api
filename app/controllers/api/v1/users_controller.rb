class Api::V1::UsersController < ApplicationController
  include SearchableParams

  # GET /api/v1/users
  def index
    users = User
    users = User.search(search_params) if search_params.present?

    render json: users.all
  end

  # GET /api/v1/users/1
  def show
    user = User.find(params[:id].to_i)
    render json: user
  end
end
