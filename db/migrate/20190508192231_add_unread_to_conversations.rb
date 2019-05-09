# frozen_string_literal: true

class AddUnreadToConversations < ActiveRecord::Migration[5.2]
  def change
    add_column :conversations, :unread, :boolean, default: true, null: false
  end
end
