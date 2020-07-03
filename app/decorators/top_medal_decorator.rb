class TopMedalDecorator < ApplicationDecorator
  delegate_all

  def image_title
    "#{medal.name}: #{achievements_count} * #{medal.score}pts = #{achievements_count * medal.score}pts"
  end
end
