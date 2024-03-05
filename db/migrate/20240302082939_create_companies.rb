class CreateCompanies < ActiveRecord::Migration[7.0]
  def change
    create_table :companies do |t|
      t.string :name,            null: false
      t.string :email,           null: false
      t.string :password_digest, null: false
      t.string :industry
      t.text :description
      t.text :home_page_url

      t.timestamps
    end
  end
end
