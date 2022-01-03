# frozen_string_literal: true

class AssignInitialChallenges < ActiveRecord::Migration[6.1]
  def up
    User.find_by(email: 'jimmyyoshi@gmail.com').battle_passes.last.tap do |bp|
      Challenges::Templates::TEMPLATES.sample(3).each do |challenge|
        challenge.battle_pass = bp
        challenge.save!
      end
    end
  end

  def down
    Challenge.destroy_all
  end
end
