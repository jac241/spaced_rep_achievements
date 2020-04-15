class PopulateMedals < ActiveRecord::Migration[6.0]
  def up
    h3 = Family.create!(name: "Halo 3")
    mw2 = Family.create!(name: "Call of Duty: Modern Warfare 2")
    h5 = Family.create!(name: "Halo 5")

    [
      {
        client_medal_id: "Double Kill",
        name: "Double Kill",
        family: h3,
        rank: 2,
        score: 4,
      },
      {
        client_medal_id: "Triple Kill",
        name: "Triple Kill",
        family: h3,
        rank: 3,
        score: 6,
      },
      {
        client_medal_id: "Overkill",
        name: "Overkill",
        family: h3,
        rank: 4,
        score: 8,
      },
      {
        client_medal_id: "Killtacular",
        name: "Killtacular",
        family: h3,
        rank: 5,
        score: 10,
      },
      {
        client_medal_id: "Killtrocity",
        name: "Killtrocity",
        family: h3,
        rank: 6,
        score: 12,
      },
      {
        client_medal_id: "Killimanjaro",
        name: "Killimanjaro",
        family: h3,
        rank: 7,
        score: 14,
      },
      {
        client_medal_id: "Killtastrophe",
        name: "Killtastrophe",
        family: h3,
        rank: 8,
        score: 16,
      },
      {
        client_medal_id: "Killpocalypse",
        name: "Killpocalypse",
        family: h3,
        rank: 9,
        score: 18,
      },
      {
        client_medal_id: "Killionaire",
        name: "Double Kill",
        family: h3,
        rank: 10,
        score: 20,
      },
    ].each { |m| Medal.create!(m) }
  end

  def down
    Medal.delete_all
    Family.delete_all
  end
end
