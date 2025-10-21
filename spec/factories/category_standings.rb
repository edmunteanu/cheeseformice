FactoryBot.define do
  factory :category_standing do
    association :player

    normal_score { 0 }
    normal_rank { nil }
    previous_normal_rank { nil }

    survivor_score { 0 }
    survivor_rank { nil }
    previous_survivor_rank { nil }

    racing_score { 0 }
    racing_rank { nil }
    previous_racing_rank { nil }

    defilante_score { 0 }
    defilante_rank { nil }
    previous_defilante_rank { nil }
  end
end
