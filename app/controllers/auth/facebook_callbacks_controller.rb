class Auth::FacebookCallbacksController < ApplicationController
  def create
    @user = FacebookService.call!(facebook_params[:access_token])
    @client_id, @token = @user.create_token
    @user.save

    sign_in :user, @user, store: false, bypass: false
    update_headers

    render json: @user, status: :ok
  rescue ActiveRecord::ActiveRecordError => exception
    render json: { error: exception.message }, status: :internal_server_error
  rescue FacebookError => exception
    render json: { error: exception.message }, status: :bad_request
  end

  private

  def facebook_params
    params.require(:facebook).permit(:access_token)
  end

  def update_headers
    new_auth_header = @user.build_auth_header(@token, @client_id)
    response.headers.merge!(new_auth_header)
  end
end
