class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.references :user,            null: false, foreign_key: { to_table: :users }
      t.references :goal,            null: false, foreign_key: { to_table: :goals }
      t.text :content
      t.datetime :completion_limits, null: false
      t.datetime :completed_at

      t.timestamps
    end
  end
end
