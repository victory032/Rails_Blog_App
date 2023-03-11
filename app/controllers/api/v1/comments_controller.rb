class Api::V1::CommentsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    user = User.find(params[:user_id])
    post = user.posts.find(params[:post_id])
    comments = post.comments
    render json: comments
  end

  def create
    post = Post.find(params[:post_id])
    author = post.author
    @comment = Comment.new(comment_params)
    @comment.post = post
    @comment.author = current_user

    if @comment.save
      render json: @comment, status: :created
    else
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    author = @comment.post.author
    post = @comment.post

    if @comment.destroy
      render json: { message: 'Comment deleted' }, status: :ok
    else
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:text)
  end
end
