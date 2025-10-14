FactoryBot.define do
  factory :player do
    sequence(:a801_id) { |n| n }
    updated_last_7_days { false }

    sequence(:name) { |n| "Player#{n}" }
    registration_date { Time.current }

    title { "0" }
    unlocked_titles { "0" }

    experience { 0 }

    look { "1;0,0,9,0,0,0,0,0,0,0,0,0" }
    badges { "" }
    dress_list { "" }
    mouse_color { "78583a" }
    shaman_color { "95d9d6" }
    skills { "" }

    stats_reliability { 0 }
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
