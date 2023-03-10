class PostsController < ApplicationController
  load_and_authorize_resource

  def index
    @user = User.find(params[:user_id])
    @posts = Post.includes(:author).paginate(page: params[:page], per_page: 3)
  end

  def show
    @user = User.find(params[:user_id])
    @post = Post.find_by(id: params[:id])
  end

  def new
    @post = Post.new
    user_id = params[:user_id].to_i

    return if current_user.id == user_id

    authorize! :create, @post
  end

  def create
    @post = Post.new(post_params)
    @post.comments_counter = 0
    @post.likes_counter = 0
    author = current_user
    @post.author = author
    if @post.save
      flash[:success] = 'Post successfully added!'
      redirect_to user_posts_path(current_user, @post)
    else
      flash.now[:error] = 'Post creation failed!'
      render :new
    end
  end

  def destroy
    user = current_user
    @post = Post.find_by(id: params[:id], author_id: params[:user_id])

    if @post.destroy
      flash[:notice] = 'Post deleted!'
    else
      flash[:alert] = 'Error! Please try again later.'
    end
    redirect_to user_posts_path(user)
  end

  private

  def post_params
    params.require(:post).permit(:title, :text)
  end
end
