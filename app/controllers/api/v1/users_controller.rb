class Api::V1::UsersController < ApplicationController
  def index
    @users = User.all
    if @users
      render json: @users, status: 200
    else
      render json: { error: 'Users not found' }, status: 404
    end
  end

  def show
    @user = User.find(params[:id])
    if @user
      render json: @user, status: 200
    else
      render json: { error: 'User not found' }, status: 404
    end
  end
end
