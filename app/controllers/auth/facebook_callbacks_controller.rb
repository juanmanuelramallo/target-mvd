# frozen_string_literal: true

module Auth
  class FacebookCallbacksController < ApplicationController
    def create
      @client_id, @token = user.create_token
      user.save!

      sign_in :user, user, store: false, bypass: false
      update_headers

      render json: serialize_resource(user, UserSerializer), status: :ok
    rescue FacebookError => e
      render_error(:bad_request, [e.message])
    end

    private

    def facebook_params
      params.require(:facebook).permit(:access_token)
    end

    def update_headers
      new_auth_header = @user.build_auth_header(@token, @client_id)
      response.headers.merge!(new_auth_header)
    end

    def user
      @user ||= FacebookService.call!(facebook_params[:access_token])
    end
  end
end
