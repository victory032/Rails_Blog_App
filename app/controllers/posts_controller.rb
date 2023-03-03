class PostsController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @posts = Post.find_by(author_id: params[:id])
  end

  def show
    @post = Post.find_by(id: params[:id])
  end
end
