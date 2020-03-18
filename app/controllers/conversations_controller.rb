# frozen_string_literal: true

class ConversationsController < ApplicationController
  before_action :authenticate_user!

  def create
    conversation = Conversation.new(conversation_params.merge(initiator_id: current_user.id))

    render json: serialized_conversation(conversation) if conversation.save!
  end

  def index
    render json: serialize_collection(current_user.conversations, ConversationSerializer)
  end

  def show
    render json: serialized_conversation(conversation)
  end

  def update
    return unless conversation.update!(update_params)

    render json: serialized_conversation(conversation), status: :ok
  end

  private

  def serialized_conversation(conversation)
    serialize_resource(conversation, ConversationSerializer, params: { current_user: current_user })
  end

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
    %w[target initiator]
  end

  def update_params
    @update_params ||= if conversation.messages.last&.user == current_user
                         conversation_update_params.except :unread
                       else
                         conversation_update_params
                       end
  end
end
