# frozen_string_literal: true

class CreateTargets < ActiveRecord::Migration[5.2]
  def change
    create_table :targets do |t|
      t.belongs_to :topic, foreign_key: true
      t.belongs_to :user, foreign_key: true
      t.integer :area_length, default: 0, null: false
      t.float :lat
      t.float :lng
      t.string :title

      t.timestamps
    end
  end
end
