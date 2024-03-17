class CreateTimelines < ActiveRecord::Migration[7.0]
  def change
    create_table :timelines do |t|
      t.references :user, null: false, foreign_key: { to_table: :users }
      t.text :content
      t.text :url

      t.timestamps
    end
  end
end
