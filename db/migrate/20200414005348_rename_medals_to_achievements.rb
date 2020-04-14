class RenameMedalsToAchievements < ActiveRecord::Migration[6.0]
  def change
    rename_table :medals, :achievements
  end
end
