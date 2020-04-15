class AddCallToMedals < ActiveRecord::Migration[6.0]
  def change
    add_column :medals, :call, :string
  end
end
