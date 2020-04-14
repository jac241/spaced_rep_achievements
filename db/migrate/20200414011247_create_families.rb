class CreateFamilies < ActiveRecord::Migration[6.0]
  def change
    create_table :families, id: :uuid do |t|
      t.string :name, null: false
    end

    add_reference :medals, :family, foreign_key: true, type: :uuid
  end
end
