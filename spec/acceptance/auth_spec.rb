# frozen_string_literal: true

require_relative '../support/acceptance_tests_helper'

resource 'Auth' do
  header 'Content-Type', 'application/json'

  let(:user) { create :user }

  route '/auth', 'Registrations' do
    post 'Create' do
      with_options required: true do
        attribute :email, 'Email'
        attribute :full_name, 'Full name'
        attribute :gender, 'Gender'
        attribute :password, 'Password'
      end

      let(:new_user) { build :user }
      let(:email) { new_user.email }
      let(:full_name) { new_user.full_name }
      let(:gender) { new_user.gender }
      let(:password) { 'P@55word' }

      example 'Ok' do
        do_request

        expect(status).to eq 201
      end

      example 'Bad' do
        do_request email: ''

        expect(status).to eq 422
      end
    end

    put 'Update' do
      header 'access-token', :access_token_header
      header 'client', :client_header
      header 'uid', :uid_header

      with_options required: true do
        attribute :current_password, 'Current password'
        attribute :email, 'New email'
        attribute :password, 'New password'
      end

      let(:current_password) { 'P@55word' }
      let(:email) { 'new-email-1@example.com' }
      let(:password) { 'n3w-p@55word' }

      example 'Ok' do
        do_request

        expect(status).to eq 200
      end
    end
  end

  route '/auth/sign_in', 'Session' do
    post 'Create' do
      with_options required: true do
        attribute :email, 'Email'
        attribute :password, 'Password'
      end

      let(:email) { user.email }
      let(:password) { 'P@55word' }

      example 'Ok' do
        do_request

        expect(status).to eq 200
      end
    end
  end

  route '/auth/sign_out', 'Session' do
    delete 'Delete' do
      header 'access-token', :access_token_header
      header 'client', :client_header
      header 'uid', :uid_header

      example 'Ok' do
        do_request

        expect(status).to eq 200
      end
    end
  end

  route '/auth/password', 'Password' do
    post 'Reset password email' do
      header 'access-token', :access_token_header
      header 'client', :client_header
      header 'uid', :uid_header

      with_options required: true do
        attribute :email, 'Email'
        attribute :redirect_url, 'Url to which the user will be redirected after visiting
                                  the link contained in the email'
      end

      let(:email) { user.email }
      let(:redirect_url) { 'http://anywhere.com' }

      example 'Ok' do
        do_request

        expect(status).to eq 200
      end
    end

    put 'Update password' do
      header 'access-token', :access_token_header
      header 'client', :client_header
      header 'uid', :uid_header

      with_options required: true do
        attribute :password, 'New password'
        attribute :password_confirmation, 'Confirm new password'
      end

      let(:password) { 'new-p@55word' }
      let(:password_confirmation) { password }

      example 'Ok' do
        do_request

        expect(status).to eq 200
      end
    end
  end

  route '/auth/facebook/callback', 'Facebook' do
    post 'Login or Sign up' do
      with_options scope: :facebook, required: true do
        attribute :access_token, 'Access token provided by facebook'
      end

      let(:access_token) { 'acc35T0k3n' }

      example 'Ok' do
        VCR.use_cassette 'facebook_service/valid' do
          do_request

          expect(status).to eq 200
        end
      end
    end
  end

  route '/auth/cable', 'Cable' do
    post 'Authorization ticket for websocket connection' do
      header 'access-token', :access_token_header
      header 'client', :client_header
      header 'uid', :uid_header

      example 'Ok' do
        do_request

        expect(status).to eq 200
      end
    end
  end
end
