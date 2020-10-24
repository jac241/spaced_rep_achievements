class AddTimesstampsToFamilies < ActiveRecord::Migration[6.0]
  def change
    add_column :families, :created_at, :datetime
    add_column :families, :updated_at, :datetime

    Family.find_each do |family|
      family.created_at = Time.now
      family.updated_at = Time.now
      family.save
    end

    change_column :families, :created_at, :datetime, null: false
    change_column :families, :updated_at, :datetime, null: false
  end
end
