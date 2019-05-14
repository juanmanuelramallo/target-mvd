# frozen_string_literal: true

module Auth
  class FacebookCallbacksController < ApplicationController
    before_action :set_user

    def create
      @client_id, @token = @user.create_token
      @user.save!

      sign_in :user, @user, store: false, bypass: false
      update_headers

      render json: @user, status: :ok
    end

    private

    def facebook_params
      params.require(:facebook).permit(:access_token)
    end

    def update_headers
      new_auth_header = @user.build_auth_header(@token, @client_id)
      response.headers.merge!(new_auth_header)
    end

    def set_user
      @user = FacebookService.call!(facebook_params[:access_token])
    rescue FacebookError => e
      render_error(:bad_request, [e.message], @user)
    end
  end
end
