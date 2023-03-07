require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  describe 'GET /index' do
    let(:user) { User.create!(name: 'John Doe', photo: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcROWm_741qaM08Rn2xI5WTsmgSnwbgkoDdhrg&usqp=CAU',bio: "This is John Doe. He is a good man.", post_counter: 0) }

    let!(:post1) do
      user.posts.create!(title: 'Post 1', text: 'This is the first post of the user.', comments_counter: 0, likes_counter: 0)
    end
    let!(:post2) do
      user.posts.create!(title: 'Post 2', text: 'This is the first post of the user.', comments_counter: 0, likes_counter: 0)
    end

    it 'displays a list of all posts' do
      get user_posts_path(user)
      expect(response).to be_successful
      user.posts.each do |post|
      expect(response.body).to include(post.text)
      end
    end
    it 'renders the index template' do
      get user_posts_path(user)
      expect(response).to render_template('index')
    end

    it 'displays pagination links when there are more than 10 posts' do
      10.times do
        user.posts.create!(title: 'Post', text: 'Body', comments_counter: 0, likes_counter: 0)
      end
      get user_posts_path(user)
      expect(response.body).to include('Pagination')
    end
  end

  describe 'GET /show' do
    let(:user) { User.create!(name: 'John Doe', photo: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcROWm_741qaM08Rn2xI5WTsmgSnwbgkoDdhrg&usqp=CAU',bio: "This is John Doe. He is a good man.", post_counter: 0) }
    let(:post) do
      user.posts.create!(title: 'Post 1', text: 'Body 1', comments_counter: 0, likes_counter: 0, created_at: 1.day.ago)
    end
    it "displays the post's text" do
      get user_post_path(user, post)
      expect(response).to be_successful
      expect(response.body).to include(post.text)
    end
    it 'renders the show template' do
      get user_post_path(user, post)
      expect(response).to render_template('show')
    end
  end
end
