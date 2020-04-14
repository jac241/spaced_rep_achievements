class RecreateMedals < ActiveRecord::Migration[6.0]
  def change
    create_table :medals, id: :uuid do |t|
      t.string :name, null: false
      t.string :client_medal_id, null: false
      t.integer :rank, null: false
      t.integer :score, null: false
    end
  end
end
