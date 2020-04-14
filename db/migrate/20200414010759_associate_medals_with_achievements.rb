class AssociateMedalsWithAchievements < ActiveRecord::Migration[6.0]
  def change
    add_reference :achievements, :medal, foreign_key: true, type: :uuid
  end
end
