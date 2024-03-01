class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false, default: ""
      t.string :image
      t.string :dream

      t.timestamps
    end
  end
end
