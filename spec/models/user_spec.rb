require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:posts).inverse_of(:author) }
    it { should have_many(:comments).inverse_of(:author) }
    it { should have_many(:likes).inverse_of(:author) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_numericality_of(:post_counter).only_integer.is_greater_than_or_equal_to(0) }
  end

  describe '#recent_posts' do
    let(:user) { User.create!(name: 'Alice', email: 'alice@gmail.com', password: '123456', post_counter: 0) }

    it 'returns all posts if the specified limit is greater than or equal to the total number of posts' do
      post1 = user.posts.create!(title: 'Post 1', text: 'Body 1', comments_counter: 0, likes_counter: 0,
                                 created_at: 1.day.ago)
      post2 = user.posts.create!(title: 'Post 2', text: 'Body 2', comments_counter: 0, likes_counter: 0,
                                 created_at: 2.days.ago)
      post3 = user.posts.create!(title: 'Post 3', text: 'Body 3', comments_counter: 0, likes_counter: 0,
                                 created_at: 3.days.ago)

      expect(user.recent_posts(3)).to eq([post1, post2, post3])
      expect(user.recent_posts(4)).to eq([post1, post2, post3])
    end

    it 'returns the most recent posts up to the specified limit' do
      post1 = user.posts.create!(title: 'Post 1', text: 'Body 1', comments_counter: 0, likes_counter: 0,
                                 created_at: 1.day.ago)
      post2 = user.posts.create!(title: 'Post 2', text: 'Body 2', comments_counter: 0, likes_counter: 0,
                                 created_at: 2.days.ago)

      expect(user.recent_posts(2)).to eq([post1, post2])
      expect(user.recent_posts(1)).to eq([post1])
    end

    it 'returns an empty array if the user has no posts' do
      expect(user.recent_posts(3)).to eq([])
    end
  end
end
