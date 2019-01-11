require 'rails_helper'
require_relative '../support/controller_test_helpers_spec.rb'

RSpec.describe PostsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }

  context "When user NOT Logged IN" do
    describe "GET #new " do
      it "responds with 302" do
        get :new
        expect(response).to have_http_status(302)
      end
    end
  end

  context "When Logged IN" do
    let(:test_post) { FactoryBot.create(:post) }

    before :each do
      login_as(user, scope: :user)
    end

    describe "GET #index " do
      it "responds with 302" do
        get :index
        expect(response).to have_http_status(302)
      end
    end

    describe "GET #show" do
      it "responds with 200" do
        get :show, params: { id: test_post.id }
        expect(response).to have_http_status(200)
      end
    end

    describe "POST #create" do
      it "responds creates a post in db" do
        expect { create_global_post }.to change { Post.count }.by(1)
      end

      it "creates redirects to posts url" do
        create_global_post
        expect(response).to redirect_to posts_url
      end

      it "responds creates a post in db" do
        expect { create_timeline_post }.to change { Post.count }.by(1)
      end

      it "creates redirects to the timeline" do
        create_timeline_post
        expect(response).to have_http_status(302)
      end
    end

    describe "GET #new " do
      it "responds with 200" do
        get :new
        expect(response).to have_http_status(200)
      end
    end

    describe "DELETE #destroy" do
      let!(:post_in_db) { FactoryBot.create(:post) }

      it "deletes a post from db" do
        expect { delete_post }.to change { Post.count }.by(-1)
      end

      it "responds with a redirect" do
        delete_post
        expect(response).to redirect_to user_path(post_in_db.user.id)
      end
    end

    after :all do
      logout
    end
  end
end
