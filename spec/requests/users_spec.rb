require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET /index' do
    it 'displays a list of all users' do
      get users_path
      expect(response).to be_successful
      expect(response.body).to include('Here is a list of users')
    end
    it 'renders the index template' do
      get users_path
      expect(response).to render_template('index')
    end
  end

  describe 'GET /show' do
    let(:user) { User.create!(name: 'Alice', post_counter: 0) }

    it "displays the user's name" do
      get user_path(user)
      expect(response).to be_successful
      expect(response.body).to include('Here is a single user')
    end
    it 'renders the show template' do
      get user_path(user)
      expect(response).to render_template('show')
    end
  end
end
