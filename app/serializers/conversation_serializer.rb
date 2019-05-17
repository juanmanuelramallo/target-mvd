# frozen_string_literal: true

class ConversationSerializer < ActiveModel::Serializer
  has_many :messages

  belongs_to :target
  belongs_to :initiator, class_name: 'User'

  attributes :id, :unread, :status

  def unread
    object.unread?(current_user)
  end
end
