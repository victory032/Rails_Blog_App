class LikesController < ApplicationController
  def create
    post = Post.find(params[:post_id])
    author = current_user
    liked = Like.find_by(author:, post:)

    return if liked.present?

    like = post.likes.create(author:)
    redirect_to user_post_path(post.author, post) if like.persisted?
  end
end
