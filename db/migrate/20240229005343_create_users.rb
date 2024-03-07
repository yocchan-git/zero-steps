class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string  :uid,        null: false
      t.string  :name,       null: false
      t.string  :image
      t.boolean :is_hidden,  null: false, default: false

      t.timestamps
    end
  end
end
