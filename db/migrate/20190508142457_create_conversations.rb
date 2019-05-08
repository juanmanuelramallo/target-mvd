# frozen_string_literal: true

class CreateConversations < ActiveRecord::Migration[5.2]
  def change
    create_table :conversations do |t|
      t.references :target, foreign_key: true
      t.references :initiator, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
