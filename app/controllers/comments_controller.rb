class CommentsController < ApplicationController
  load_and_authorize_resource
  def new
    @comment = Comment.new
  end

  def create
    post = Post.find(params[:post_id])
    author = post.author
    @comment = Comment.new(comment_params)
    @comment.post = post
    @comment.author = current_user

    render :new unless @comment.save

    redirect_to user_post_path(author, post)
  end

  def destroy
    @comment = Comment.find(params[:id])
    author = @comment.post.author
    post = @comment.destroy
    if @comment.destroy
      flash[:notice] = 'Comment deleted!'
    else
      flash[:alert] = 'Error! Please try again later.'
    end
    redirect_to user_post_url(author, post)
  end

  private

  def comment_params
    params.require(:comment).permit(:text)
  end
end
