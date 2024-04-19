# frozen_string_literal: true

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
        skills: a801_player.skills,
      }
    end

    def map_normal_stats(a801_player)
      {
        rounds_played: a801_player.round_played,
        shaman_cheese: a801_player.shaman_cheese,
        saved_mice: a801_player.saved_mice,
        saved_mice_hard: a801_player.saved_mice_hard,
        saved_mice_divine: a801_player.saved_mice_divine,
        saved_mice_without_skills: a801_player.saved_mice_ns,
        saved_mice_hard_without_skills: a801_player.saved_mice_hard_ns,
        saved_mice_divine_without_skills: a801_player.saved_mice_divine_ns,
        cheese_gathered: a801_player.cheese_gathered,
        firsts: a801_player.first,
        bootcamp: a801_player.bootcamp
      }
    end

    def map_survivor_stats(a801_player)
      {
        survivor_rounds_played: a801_player.survivor_round_played,
        survivor_mice_killed: a801_player.survivor_mouse_killed,
        survivor_shaman_rounds: a801_player.survivor_shaman_count,
        survivor_survived_rounds: a801_player.survivor_survivor_count
      }
    end

    def map_racing_stats(a801_player)
      {
        racing_rounds_played: a801_player.racing_round_played,
        racing_finished_maps: a801_player.racing_finished_map,
        racing_firsts: a801_player.racing_first,
        racing_podiums: a801_player.racing_podium
      }
    end

    def map_defilante_stats(a801_player)
      {
        defilante_rounds_played: a801_player.defilante_round_played,
        defilante_finished_maps: a801_player.defilante_finished_map,
        defilante_points: a801_player.defilante_points
      }
    end
  end
end
