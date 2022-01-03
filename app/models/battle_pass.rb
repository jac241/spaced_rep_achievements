class BattlePass < ApplicationRecord
  belongs_to :user
  has_many :challenges

  def level
    calculate_level(xp)
  end

  def on_challenge_completed!(challenge)
    with_lock do
      self.xp += challenge.xp
      save!
    end
  end

  private

  def calculate_level(input_xp)
    base_xp = 500
    exponent = 1.5

    level_acc = 0
    xp_acc = 0
    while xp_acc < input_xp
      xp_acc = base_xp * (level_acc**exponent)
      level_acc += 1
    end

    [level_acc - 1, 1].max
  end
end
