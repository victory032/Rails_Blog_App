class PostsController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @posts = Post.find_by(author_id: params[:id])
  end

  def show
    @user = User.find(params[:user_id])
    @post = Post.find_by(id: params[:id])
  end

  def new
    @post = Post.new
    render :new
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

  private

  def post_params
    params.require(:post).permit(:title, :text)
  end
end
