require 'rails_helper'

RSpec.describe 'Posts', type: :system do
  fixtures :users, :posts, :comments
  let(:user1) { users(:one) }
  describe 'Index page' do
    it "can see the user's profile picture." do
      visit user_posts_path(user1)
      expect(page).to have_selector("img[src='#{user1.photo}']")
    end
    it "can see the user's username." do
      visit user_posts_path(user1)
      expect(page).to have_content(user1.name)
    end
    it 'can see the number of posts the user has written.' do
      visit user_posts_path(user1)
      expect(page).to have_content(user1.post_counter)
    end
    it "can see a post's title." do
      visit user_posts_path(user1)
      user1.posts.limit(3).each do |post|
        expect(page).to have_content("Post##{post.id}")
      end
    end
    it "can see some of the post's body." do
      visit user_posts_path(user1)
      user1.posts.each do |post|
        expect(page).to have_content(post.text)
      end
    end
    it 'can see the first comments on a post.' do
      visit user_posts_path(user1)
      post1 = user1.posts.first
      expect(page).to have_content(post1.comments.first.text)
    end
    it 'can see how many comments a post has.' do
      visit user_posts_path(user1)
      user1.posts.each do |post|
        expect(page).to have_content(post.comments_counter)
      end
    end
    it 'can see how many likes a post has.' do
      visit user_posts_path(user1)
      user1.posts.each do |post|
        expect(page).to have_content(post.likes_counter)
      end
    end
    it 'I can see a section for pagination if there are more posts than fit on the view.' do
      visit user_posts_path(user1)
      expect(page).to have_selector('.pagination')
      within '.pagination' do
        expect(page).to have_selector('.current', text: '1')
        click_link 'Next'
        expect(page).to have_selector('.current', text: '2')
        click_link 'Previous'
        expect(page).to have_selector('.current', text: '1')
        click_link '2'
        expect(page).to have_selector('.current', text: '2')
      end
    end
    it "When I click on a post, it redirects me to that post's show page." do
      post = posts(:post1)
      visit user_posts_path(user1)
      expect(page).to have_link("Post##{post.id}", href: user_post_path(user1, post))
      click_link "Post##{post.id}"
      expect(current_path).to eq('/users/1/posts' || user_post_path(user1, post))
    end
  end
end
