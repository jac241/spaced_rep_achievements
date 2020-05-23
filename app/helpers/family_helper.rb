module FamilyHelper
  def leaderboard_family_nav_link(leaderboard_family:, link_family:)
    classes = ["nav-link"]

    if leaderboard_family == link_family
      classes << "active"
    end

      link_to(
        link_family.name,
        family_leaderboard_path(link_family, 'monthly'),
        { class: classes }
      )
  end
end
