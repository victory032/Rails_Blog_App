require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'associations' do
    it { should belong_to(:author).class_name('User') }
    it { should belong_to(:post) }
  end

  describe 'update_post_comments_counter' do
    let!(:user) { User.create!(name: 'John Doe', email: 'jhone@doe.com', password: '123456', post_counter: 0) }
    let!(:post) { Post.create!(title: 'My First Post', author: user, comments_counter: 0, likes_counter: 0) }
    let!(:comment) { Comment.new(author: user, post:) }

    it 'increments the post comment counter after saving' do
      expect { comment.save }.to change { post.reload.comments_counter }.by(1)
    end
  end
end
