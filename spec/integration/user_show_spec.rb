require 'rails_helper'

RSpec.describe 'Users', type: :system do
  fixtures :users, :posts
  let(:user1) { users(:one) }
  let(:user2) { users(:two) }
  let(:user3) { users(:three) }
  describe 'show page' do
    it "can see the user's profile picture." do
      visit user_path(user1)
      expect(page).to have_selector("img[src='#{user1.photo}']")
      visit user_path(user2)
      expect(page).to have_selector("img[src='#{user2.photo}']")
      visit user_path(user3)
      expect(page).to have_selector("img[src='#{user3.photo}']")
    end
    it "can see the user's username" do
      visit user_path(user1)
      expect(page).to have_content(user1.name)
      visit user_path(user2)
      expect(page).to have_content(user2.name)
      visit user_path(user3)
      expect(page).to have_content(user3.name)
    end
    it 'can see the number of posts user has written.' do
      visit user_path(user1)
      expect(page).to have_content(user1.post_counter)
      visit user_path(user2)
      expect(page).to have_content(user2.post_counter)
      visit user_path(user3)
      expect(page).to have_content(user3.post_counter)
    end
    it "can see the user's bio." do
      visit user_path(user1)
      expect(page).to have_content(user1.bio)
      visit user_path(user2)
      expect(page).to have_content(user2.bio)
      visit user_path(user3)
      expect(page).to have_content(user3.bio)
    end
    it "can see the user's first 3 posts." do
      visit user_path(user1)
      user1.recent_posts.each do |post|
        expect(page).to have_content(post.text)
      end
    end
    it "can see a button that lets me view all of a user's posts." do
      visit user_path(user1)
      expect(page).to have_link('See all posts', href: user_posts_path(user1))
    end
    it "When I click a user's post, it redirects me to that post's show page." do
      visit user_posts_path(user1)
      user1.posts.limit(3).each do |post|
        click_link "Post##{post.id}"
        expect(page).to have_current_path(user_post_path(user1, post))
        expect(page).to have_content(post.text)
        visit user_posts_path(user1)
      end
    end
    it "When I click to see all posts, it redirects me to the user's post's index page." do
      visit user_path(user1)
      click_link 'See all posts'
      expect(page).to have_current_path(user_posts_path(user1))
    end
  end
end
