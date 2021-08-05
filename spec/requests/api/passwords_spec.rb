require 'rails_helper'

RSpec.describe 'Passwords', type: :request do
  let(:user) { create :user }
  let(:valid_headers) { user.create_new_auth_token }

  describe 'POST /create' do
    it 'resets password' do
      post '/api/auth/password', params: {
        email: user.email,
        redirect_url: 'http://localhost:3000/reset-password'
      }
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'PUT /update' do
    it 'updates password' do
      put '/api/auth/password', params: {
        current_password: user.password,
        password: 'newpassword',
        password_confirmation: 'newpassword',
      }, headers: valid_headers, as: :json
      user.reload
      expect(user.valid_password?('newpassword')).to be_truthy
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end

    it 'renders a JSON response with errors' do
      put '/api/auth/password',
        params: {
          current_password: user.password,
          password: 'newpassword',
          password_confirmation: 'newpassword'
        }, headers: {}, as: :json
      expect(response).to have_http_status(:unauthorized)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(json_response).to eq({:success => false, :errors => ["Unauthorized"]})
    end

    it 'renders a JSON response with errors when passing wrong current password' do
      put '/api/auth/password',
        params: {
          current_password: '1234',
          password: 'newpassword',
          password_confirmation: 'newpassword'
        }, headers: valid_headers, as: :json
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(json_response).to eq(
        {
          :success => false,
          :errors => {
            :current_password => [
              "is invalid"
            ],
            :full_messages => [
              "Current password is invalid"
            ]
          }
        }
      )
    end
  end
end
