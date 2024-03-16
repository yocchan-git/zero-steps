class CreateReactions < ActiveRecord::Migration[7.0]
  def change
    create_table :reactions do |t|
      t.references :user, null: false, foreign_key: { to_table: :users }
      t.references :reactionable, polymorphic: true, null: false

      t.timestamps
    end

    add_index :reactions, [:user_id, :reactionable_type, :reactionable_id], unique: true, name: 'index_reactions_on_user_and_reactionable'
  end
end
