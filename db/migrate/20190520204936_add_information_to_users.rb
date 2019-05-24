# frozen_string_literal: true

class AddInformationToUsers < ActiveRecord::Migration[5.2]
  def change
    change_table :users, bulk: true do |t|
      t.column :full_name, :string, null: false, default: ''
      t.column :gender, :integer, null: false, default: 0
    end
  end
end
