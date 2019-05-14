# frozen_string_literal: true

class ConversationsController < ApplicationController
  before_action :authenticate_user!

  def create
    conversation = ConversationService.call(conversation_params.merge(current_user: current_user))

    render json: conversation, status: :created if conversation.save!
  rescue ConversationNotAllowedError => e
    render_not_found(e)
  end

  def index
    render json: current_user.conversations
  end

  def show
    render json: conversation
  end

  def update
    render json: conversation, status: :ok if conversation.update!(update_params)
  end

  private

  def conversation
    @conversation ||= current_user.conversations.find params[:id]
  end

  def conversation_params
    params.require(:conversation).permit(:target_id, :initiator_id)
  end

  def conversation_update_params
    params.require(:conversation).permit(:unread)
  end

  def update_params
    @update_params ||= if conversation.messages.last&.user == current_user
                         conversation_update_params.except :unread
                       else
                         conversation_update_params
                       end
  end
end
