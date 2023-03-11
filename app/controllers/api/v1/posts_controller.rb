class Api::V1::PostsController < ApplicationController
  before_action :set_user, only: %i[index show create destroy]
  before_action :set_post, only: %i[show destroy]

  PER_PAGE = 3

  def index
    @posts = @user.posts.includes(:author).paginate(page: params[:page], per_page: PER_PAGE)
    render json: @posts
  end

  def show
    if @post
      render json: @post
    else
      render json: { error: 'Post not found' }, status: :not_found
    end
  end

  def create
    @post = Post.new(post_params)
    @post.comments_counter = 0
    @post.likes_counter = 0
    @post.author = @user
    authorize! :create, @post
    if @post.save
      render json: @post, status: :created
    else
      render json: { error: 'Post creation failed' }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize! :destroy, @post
    if @post.destroy
      render json: { message: 'Post deleted' }, status: :ok
    else
      render json: { error: 'Post deletion failed' }, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_post
    @post = @user.posts.find_by(id: params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :text)
  end
end
