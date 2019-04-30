class DeviseTokenAuthUpdateUsers < ActiveRecord::Migration[5.2]
  def change
    change_table :users, bulk: true do |t|
      ## Required
      t.string :provider, null: false, default: 'email'
      t.string :uid, null: false, default: ''

      ## Tokens
      t.json :tokens
    end

    add_index :users, %i[uid provider], unique: true
  end
end
