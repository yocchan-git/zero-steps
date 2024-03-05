class AddResetToCompanies < ActiveRecord::Migration[7.0]
  def change
    add_column :companies, :reset_digest, :string
    add_column :companies, :reset_sent_at, :datetime
  end
end
