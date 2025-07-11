require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :request do
  describe 'POST #create' do
    context 'with valid parameters' do
      let(:valid_params) do
        {
          user: {
            first_name: 'John',
            last_name: 'Doe',
            email: 'john@example.com',
            password: 'password123',
            password_confirmation: 'password123',
            role: 'student'
          }
        }
      end

      it 'creates a new user' do
        expect {
          post user_registration_path, params: valid_params
        }.to change(User, :count).by(1)
      end

      it 'redirects to root path' do
        post user_registration_path, params: valid_params
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
