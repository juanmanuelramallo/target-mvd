# frozen_string_literal: true

class ConversationSerializer < ActiveModel::Serializer
  attributes :id, :unread, :status

  belongs_to :initiator, class_name: 'User'
  belongs_to :target

  has_many :messages

  def unread
    object.unread?(current_user)
  end
end
