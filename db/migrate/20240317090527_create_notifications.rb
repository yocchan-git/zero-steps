class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: { to_table: :users }
      t.text :content
      t.text :url
      t.boolean :is_read, null: false, default: false

      t.timestamps
    end
  end
end
