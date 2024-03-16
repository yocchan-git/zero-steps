class CreateCompletePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :complete_posts do |t|
      t.references :user, null: false, foreign_key: { to_table: :users }
      t.references :complete_postable, polymorphic: true, null: false
      t.text :content

      t.timestamps
    end

    add_index :complete_posts, [:complete_postable_type, :complete_postable_id], unique: true, name: 'index_complete_posts_on_postable'
  end
end
