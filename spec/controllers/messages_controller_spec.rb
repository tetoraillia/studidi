require 'rails_helper'

RSpec.describe MessagesController, type: :controller do
  include Devise::Test::ControllerHelpers
  let(:user) { create(:user) }
  let(:message) { create(:message, user: user) }

  describe "GET #index" do
    context "when user is authenticated" do
      before { sign_in user }

      it "returns a successful response" do
        get :index
        expect(response).to be_successful
      end

      it "assigns all messages ordered by created_at" do
        get :index
        expect(assigns(:messages)).to eq(Message.all.order(created_at: :asc))
      end

      it "assigns current user" do
        get :index
        expect(assigns(:user)).to eq(user)
      end

      it "renders the index template" do
        get :index
        expect(response).to render_template(:index)
      end
    end

    context "when user is not authenticated" do
      it "redirects to login page" do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST #create" do
    context "when user is authenticated" do
      before { sign_in user }

      context "with valid parameters" do
        let(:valid_attributes) { { message: { content: "Test message" } } }

        it "creates a new message" do
          expect {
            post :create, params: valid_attributes
          }.to change(Message, :count).by(1)
        end

        it "associates the message with the current user" do
          post :create, params: valid_attributes
          expect(Message.last.user).to eq(user)
        end

        it "returns JSON with the created message" do
          post :create, params: valid_attributes
          puts "Response body: #{response.body.inspect}"
          puts "Response status: #{response.status}"
          puts "Response content type: #{response.content_type}"

          expect(response.content_type).to match(/^application\/json(; charset=utf-8)?$/)
          expect(response).to have_http_status(:created)
          expect(JSON.parse(response.body)).to have_key("id")
          expect(JSON.parse(response.body)).to have_key("content")
          expect(JSON.parse(response.body)["content"]).to eq("Test message")
          expect(JSON.parse(response.body)["user"]).to be_a(Hash)
          expect(JSON.parse(response.body)["user"]["id"]).to eq(user.id)
        end
      end

      context "with invalid parameters" do
        let(:invalid_attributes) { { message: { content: "" } } }

        it "does not create a new message" do
          expect {
            post :create, params: invalid_attributes
          }.not_to change(Message, :count)
        end
      end
    end

    context "when user is not authenticated" do
      it "redirects to login page" do
        post :create, params: { message: { content: "Test message" } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
