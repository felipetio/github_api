class Api::V1::UsersController < ApplicationController

  # GET /api/v1/users
  def index
    users = User.all

    render json: users
  end

  # GET /api/v1/users/1
  def show
    user = User.find(params[:id].to_i)
    render json: user
  end

  private
    # Only allow a trusted parameter "white list" through.
    def user_params
      params.fetch(:user, {})
    end
end
