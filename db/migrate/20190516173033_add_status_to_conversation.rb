# frozen_string_literal: true

class AddStatusToConversation < ActiveRecord::Migration[5.2]
  def change
    add_column :conversations, :status, :integer, default: 0, null: false
  end
end
