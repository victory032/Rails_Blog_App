require 'rails_helper'

RSpec.describe 'Posts', type: :system do
  fixtures :users, :posts, :comments
  let(:user1) { users(:one) }
  let(:post) { posts(:post1)}
  describe 'show page' do
    it "can see the post's title." do
      visit user_post_path(user1, post)
      expect(page).to have_content("Post ##{post.id}")
    end
    it "can see who wrote the post." do
      visit user_post_path(user1, post)
      expect(page).to have_content(post.author.name)
    end
    it "can see how many comments it has." do
      visit user_post_path(user1, post)
      expect(page).to have_content(post.comments.count)
    end
    it "can see how many likes it has." do
      visit user_post_path(user1, post)
      expect(page).to have_content(post.likes.count)
    end
    it "can see the post body." do
      visit user_post_path(user1, post)
      expect(page).to have_content(post.text)
    end
    it "can see the username of each commenter." do
      visit user_post_path(user1, post)
      post.comments.each do |comment|
        expect(page).to have_content(comment.author.name)
      end
    end
    it "can see the comment each commenter left." do
      visit user_post_path(user1, post)
      post.comments.each do |comment|
        expect(page).to have_content(comment.text)
      end
    end
  end
end
