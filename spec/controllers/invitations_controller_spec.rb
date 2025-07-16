require 'rails_helper'

RSpec.describe InvitationsController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:user) { create(:user) }
  let(:teacher) { create(:user, :teacher) }
  let(:course) { create(:course, instructor: teacher, title: "Valid Course Title") }

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "GET #new" do
    subject { get :new, params: { course_id: course.id } }

    context "when user is signed in as a teacher" do
      before { sign_in teacher }

      it "assigns a new invitation to @invitation" do
        subject
        expect(assigns(:invitation)).to be_a_new(Invitation)
      end

      it "renders the new template" do
        subject
        expect(response).to render_template("new")
      end
    end

    context "when user is not a teacher" do
      before { sign_in user }

      it "redirects to root path with alert" do
        subject
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("You are not authorized to perform this action.")
      end
    end

    context "when user is not signed in" do
      it "redirects to sign in page" do
        subject
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST #create" do
    let(:invitation_params) { { email: Faker::Internet.email } }
    subject { post :create, params: { course_id: course.id, invitation: invitation_params } }

    context "when user is signed in as a teacher" do
      before { sign_in teacher }

      context "with valid parameters" do
        it "creates a new invitation" do
          expect { subject }.to change(Invitation, :count).by(1)
        end

        it "redirects to the course path with a notice" do
          subject
          expect(response).to redirect_to(course_path(course))
          expect(flash[:notice]).to eq("Invitation sent.")
        end
      end

      context "with invalid parameters" do
        let(:invitation_params) { { email: "" } }

        it "does not create a new invitation" do
          expect { subject }.to_not change(Invitation, :count)
        end
      end
    end

    context "when user is not a teacher" do
      before { sign_in user }

      it "redirects to root path with alert" do
        subject
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("You are not authorized to perform this action.")
      end
    end

    context "when user is not signed in" do
      it "redirects to sign in page" do
        subject
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
