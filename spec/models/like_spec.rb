require 'rails_helper'

RSpec.describe Like, type: :model do
  describe 'associations' do
    it { should belong_to(:author).class_name('User') }
    it { should belong_to(:post) }
  end

  describe 'update_post_likes_counter' do
    let!(:user) { User.create!(name: 'John Doe', post_counter: 0) }
    let!(:post) { Post.create!(title: 'My First Post', author: user, comments_counter: 0, likes_counter: 0) }
    let!(:like) { Like.new(author: user, post:) }

    it 'increments the post likes counter after saving' do
      expect { like.save }.to change { post.reload.likes_counter }.by(1)
    end
  end
end
