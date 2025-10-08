FactoryBot.define do
  factory :change_log do
    player

    rounds_played { 0 }
    shaman_cheese { 0 }
    saved_mice { 0 }
    saved_mice_hard { 0 }
    saved_mice_divine { 0 }
    saved_mice_without_skills { 0 }
    saved_mice_hard_without_skills { 0 }
    saved_mice_divine_without_skills { 0 }
    cheese_gathered { 0 }
    firsts { 0 }
    bootcamp { 0 }

    survivor_rounds_played { 0 }
    survivor_mice_killed { 0 }
    survivor_shaman_rounds { 0 }
    survivor_survived_rounds { 0 }

    racing_rounds_played { 0 }
    racing_finished_maps { 0 }
    racing_firsts { 0 }
    racing_podiums { 0 }

    defilante_rounds_played { 0 }
    defilante_finished_maps { 0 }
    defilante_points { 0 }
  end
end
