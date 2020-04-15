class AddRestOfInitialMedals < ActiveRecord::Migration[6.0]

  def up
    h3 = Family.find_by_name("Halo 3")
    mw2 = Family.find_by_name("Call of Duty: Modern Warfare 2")
    h5 = Family.find_by_name("Halo 5")

    [
      {
        client_medal_id: "Killing Spree",
        name: "Killing Spree",
        family: h3,
        rank: 5,
        score: 5,
      },
      {
        client_medal_id: "Killing Frenzy",
        name: "Killing Frenzy",
        family: h3,
        rank: 10,
        score: 10,
      },
      {
        client_medal_id: "Running Riot",
        name: "Running Riot",
        family: h3,
        rank: 15,
        score: 15,
      },
      {
        client_medal_id: "Rampage",
        name: "Rampage",
        family: h3,
        rank: 20,
        score: 20,
      },
      {
        client_medal_id: "Untouchable",
        name: "Untouchable",
        family: h3,
        rank: 25,
        score: 25,
      },
      {
        client_medal_id: "Invincible",
        name: "Invincible",
        family: h3,
        rank: 30,
        score: 30,
      },
      {
        client_medal_id: "Perfection",
        name: "Perfection",
        family: h3,
        rank: 50,
        score: 75,
      },
    ].each { |m| Medal.create!(m) }

    [
      {
        client_medal_id: "mw2_uav",
        name: "UAV",
        call: "UAV recon standing by",
        family: mw2,
        rank: 3,
        score: 3,
      },
      {
        client_medal_id: "mw2_care_package",
        name: "Care Package",
        family: mw2,
        call: "Care package waiting for your mark",
        rank: 4,
        score: 4,
      },
      {
        client_medal_id: "mw2_predator_missile",
        name: "Predator Missle",
        call: "Predator missile ready for launch",
        family: mw2,
        rank: 5,
        score: 5,
      },
      {
        client_medal_id: "mw2_precision_airstrike",
        name: "Precision Airstrike",
        call: "Airstrike standing by",
        family: mw2,
        rank: 6,
        score: 6,
      },
      {
        client_medal_id: "mw2_harrier_strike",
        name: "Harrier Strike",
        call: "Harrier's waiting for your mark",
        family: mw2,
        rank: 7,
        score: 7,
      },
      {
        client_medal_id: "mw2_emergency_airdrop",
        name: "Emergency Airdrop",
        call: "Emergency airdrop, show us where you want it",
        family: mw2,
        rank: 8,
        score: 8,
      },
      {
        client_medal_id: "mw2_pave_low",
        name: "Pave Low",
        call: "Pave low ready for deployment",
        family: mw2,
        rank: 9,
        score: 9,
      },
      {
        client_medal_id: "mw2_chopper_gunner",
        name: "Chopper Gunner",
        call: "Chopper ready for deployment",
        family: mw2,
        rank: 11,
        score: 11,
      },
      {
        client_medal_id: "mw2_emp",
        name: "EMP",
        call: "EMP ready to go",
        family: mw2,
        rank: 15,
        score: 15,
      },
      {
        client_medal_id: "mw2_tactical_nuke",
        name: "Tactical Nuke",
        call: "Tactical nuke ready, turn the key",
        family: mw2,
        rank: 25,
        score: 25,
      },
    ].each { |m| Medal.create!(m) }


    [
      {
        client_medal_id: "halo_5_double_kill",
        name: "Double Kill",
        family: h5,
        rank: 2,
        score: 4,
      },
      {
        client_medal_id: "halo_5_triple_Kill", # intentional
        name: "Triple Kill",
        family: h5,
        rank: 3,
        score: 6,
      },
      {
        client_medal_id: "halo_5_overkill",
        name: "Overkill",
        family: h5,
        rank: 4,
        score: 8,
      },
      {
        client_medal_id: "halo_5_killtacular",
        name: "Killtacular",
        family: h5,
        rank: 5,
        score: 10,
      },
      {
        client_medal_id: "halo_5_killtrocity",
        name: "Killtrocity",
        family: h5,
        rank: 6,
        score: 12,
      },
      {
        client_medal_id: "halo_5_killimanjaro",
        name: "Killimanjaro",
        family: h5,
        rank: 7,
        score: 14,
      },
      {
        client_medal_id: "halo_5_killtastrophe",
        name: "Killtastrophe",
        family: h5,
        rank: 8,
        score: 16,
      },
      {
        client_medal_id: "halo_5_killpocalypse",
        name: "Killpocalypse",
        family: h5,
        rank: 9,
        score: 18,
      },
      {
        client_medal_id: "halo_5_killionaire",
        name: "Killionaire",
        family: h5,
        rank: 10,
        score: 20,
      },
    ].each { |m| Medal.create!(m) }

    [
      {
        client_medal_id: "halo_5_killing_spree",
        name: "Killing Spree",
        family: h5,
        rank: 5,
        score: 5,
      },
      {
        client_medal_id: "halo_5_killing_frenzy",
        name: "Killing Frenzy",
        family: h5,
        rank: 10,
        score: 10,
      },
      {
        client_medal_id: "halo_5_running_riot",
        name: "Running Riot",
        family: h5,
        rank: 15,
        score: 15,
      },
      {
        client_medal_id: "halo_5_rampage",
        name: "Rampage",
        family: h5,
        rank: 20,
        score: 20,
      },
      {
        client_medal_id: "halo_5_untouchable",
        name: "Untouchable",
        family: h5,
        rank: 25,
        score: 25,
      },
      {
        client_medal_id: "halo_5_invincible",
        name: "Invincible",
        family: h5,
        rank: 30,
        score: 30,
      },
      {
        client_medal_id: "halo_5_unfriggenbelievable",
        name: "Unfriggenbelievable",
        family: h5,
        rank: 40,
        score: 40,
      },
      {
        client_medal_id: "halo_5_perfection",
        name: "Perfection",
        family: h5,
        rank: 50,
        score: 75,
      },
    ].each { |m| Medal.create!(m) }
  end

  def down
    Medal.delete_all
  end
end
