class CreateTimelines < ActiveRecord::Migration[7.0]
  def change
    create_table :timelines do |t|
      t.references :user, null: false, foreign_key: { to_table: :users }
      t.references :timelineable, polymorphic: true, null: false
      t.text :content

      t.timestamps
    end
  end
end
