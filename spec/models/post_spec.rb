require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:user) { User.create(name: 'John Doe', post_counter: 0) }

  describe 'associations' do
    it { should belong_to(:author).class_name('User').inverse_of(:posts) }
    it { should have_many(:comments) }
    it { should have_many(:likes) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_most(250) }
    it { should validate_numericality_of(:comments_counter).only_integer.is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:likes_counter).only_integer.is_greater_than_or_equal_to(0) }
  end

  describe 'recent_comments' do
    let!(:post) { Post.create!(title: 'My First Post', author: user, comments_counter: 0, likes_counter: 0) }
    let!(:comment1) { Comment.create!(post:, author: user, text: 'First Comment') }
    let!(:comment2) { Comment.create!(post:, author: user, text: 'Second Comment') }
    let!(:comment3) { Comment.create!(post:, author: user, text: '3rd Comment') }
    let!(:comment4) { Comment.create!(post:, author: user, text: 'fourth Comment') }
    let!(:comment5) { Comment.create!(post:, author: user, text: 'fifth Comment') }
    let!(:comment6) { Comment.create!(post:, author: user, text: 'sixth Comment') }

    it 'returns the most recent comments upto 3 for the post' do
      expect(post.recent_comments(3)).to eq([comment6, comment5, comment4])
    end

    it 'limits the number of most recent comments upto 5 for the post' do
      expect(post.recent_comments(5)).to eq([comment6, comment5, comment4, comment3, comment2])
    end
  end

  describe 'update_posts_counter' do
    let!(:post) { Post.create!(title: 'My First Post', author: user, comments_counter: 0, likes_counter: 0) }

    it 'increments the author post counter after saving' do
      expect { post.save }.to change { user.reload.post_counter }.by(1)
    end
  end
end
