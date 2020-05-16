class LeaderboardDecorator < Draper::CollectionDecorator
  def decorator_class
    LeaderDecorator
  end

  def title
    "Top 10 for #{context[:family].name}: past month"
  end
end
