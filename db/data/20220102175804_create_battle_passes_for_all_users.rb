# frozen_string_literal: true

class CreateBattlePassesForAllUsers < ActiveRecord::Migration[6.1]
  def up
    User.find_each do |u|
      u.battle_passes.create!
    end
  end

  def down
    User.find_each do |u|
      u.battle_passes.destroy_all!
    end
  end
end
