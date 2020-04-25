class LeaderboardDecorator < Draper::CollectionDecorator
  def decorator_class
    LeaderDecorator
  end

  def title
    "Top 10 for Halo 3: 1 month"
  end
end
