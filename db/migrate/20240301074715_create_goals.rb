class CreateGoals < ActiveRecord::Migration[7.0]
  def change
    create_table :goals do |t|
      t.references :user, null: false, foreign_key: { to_table: :users }
      t.string :title, null: false
      t.text :description

      t.timestamps
    end
  end
end
