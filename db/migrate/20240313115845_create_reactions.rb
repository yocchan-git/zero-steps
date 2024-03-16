class CreateReactions < ActiveRecord::Migration[7.0]
  def change
    create_table :reactions do |t|
      t.references :user, null: false, foreign_key: { to_table: :users }
      t.references :reactionable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
