module Auth
  class FacebookCallbacksController < ApplicationController
    before_action :set_user

    def create
      @client_id, @token = @user.create_token
      @user.save!

      sign_in :user, @user, store: false, bypass: false
      update_headers

      render json: @user, status: :ok
    rescue ActiveRecord::ActiveRecordError => e
      render json: { error: e.message }, status: :internal_server_error
    rescue FacebookError => e
      render json: { error: e.message }, status: :bad_request
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
    end
  end
end
