module Utils
  module PlayerMapper
    private

    def map_player(a801_player)
      {
        a801_id: a801_player.id,
        updated_last_7_days: a801_player.updatedLast7days,
        registration_date: a801_player.registration_date,
        stats_reliability: a801_player.stats_reliability,
        **map_mouse_information(a801_player),
        **map_normal_stats(a801_player),
        **map_survivor_stats(a801_player),
        **map_racing_stats(a801_player),
        **map_defilante_stats(a801_player)
      }
    end

    def map_mouse_information(a801_player)
      {
        name: a801_player.name,
        title: a801_player.title,
        unlocked_titles: a801_player.unlocked_titles,
        experience: a801_player.experience,
        look: a801_player.look,
        badges: a801_player.badges,
        dress_list: a801_player.dress_list,
        mouse_color: a801_player.color1,
        shaman_color: a801_player.color2,
        skills: a801_player.skills
      }
    end

    # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    def map_normal_stats(a801_player)
      {
        rounds_played: a801_player.round_played || 0,
        shaman_cheese: a801_player.shaman_cheese || 0,
        saved_mice: a801_player.saved_mice || 0,
        saved_mice_hard: a801_player.saved_mice_hard || 0,
        saved_mice_divine: a801_player.saved_mice_divine || 0,
        saved_mice_without_skills: a801_player.saved_mice_ns || 0,
        saved_mice_hard_without_skills: a801_player.saved_mice_hard_ns || 0,
        saved_mice_divine_without_skills: a801_player.saved_mice_divine_ns || 0,
        cheese_gathered: a801_player.cheese_gathered || 0,
        firsts: a801_player.first || 0,
        bootcamp: a801_player.bootcamp || 0
      }
    end
    # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

    def map_survivor_stats(a801_player)
      {
        survivor_rounds_played: a801_player.survivor_round_played || 0,
        survivor_mice_killed: a801_player.survivor_mouse_killed || 0,
        survivor_shaman_rounds: a801_player.survivor_shaman_count || 0,
        survivor_survived_rounds: a801_player.survivor_survivor_count || 0
      }
    end

    def map_racing_stats(a801_player)
      {
        racing_rounds_played: a801_player.racing_round_played || 0,
        racing_finished_maps: a801_player.racing_finished_map || 0,
        racing_firsts: a801_player.racing_first || 0,
        racing_podiums: a801_player.racing_podium || 0
      }
    end

    def map_defilante_stats(a801_player)
      {
        defilante_rounds_played: a801_player.defilante_round_played || 0,
        defilante_finished_maps: a801_player.defilante_finished_map || 0,
        defilante_points: a801_player.defilante_points || 0
      }
    end
  end
end
