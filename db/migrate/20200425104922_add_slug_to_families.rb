class AddSlugToFamilies < ActiveRecord::Migration[6.0]
  def change
    add_column :families, :slug, :string
    add_index :families, :slug, unique: true
  end
end
