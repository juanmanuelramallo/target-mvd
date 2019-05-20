# frozen_string_literal: true

class ConversationsController < ApplicationController
  before_action :authenticate_user!

  def create
    conversation = ConversationService.call(conversation_params.merge(current_user: current_user))

    render json: conversation, status: :created if conversation.save!
  rescue ConversationWithSameUserError => _e
    render_error(:bad_request, I18n.t('errors.conversation_with_same_user_error'))
  end

  def index
    render json: current_user.conversations, include: permitted_include
  end

  def show
    render json: conversation, include: permitted_include
  end

  def update
    render json: conversation, status: :ok if conversation.update!(update_params)
  end

  private

  def conversation
    @conversation ||= current_user.conversations.find params[:id]
  end

  def conversation_params
    params.require(:conversation).permit(:target_id)
  end

  def conversation_update_params
    params.require(:conversation).permit(:unread)
  end

  def permitted_inclusions
    %w[messages target initiator]
  end

  def update_params
    @update_params ||= if conversation.messages.last&.user == current_user
                         conversation_update_params.except :unread
                       else
                         conversation_update_params
                       end
  end
end
