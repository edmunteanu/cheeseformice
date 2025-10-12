module PlayerExtensions
  module Ratio
    # Normal ratios
    def saved_mice_ratio = normal_ratio(saved_mice)
    def saved_mice_hard_ratio = normal_ratio(saved_mice_hard)
    def saved_mice_divine_ratio = normal_ratio(saved_mice_divine)
    def saved_mice_without_skills_ratio = normal_ratio(saved_mice_without_skills)
    def saved_mice_hard_without_skills_ratio = normal_ratio(saved_mice_hard_without_skills)
    def saved_mice_divine_without_skills_ratio = normal_ratio(saved_mice_divine_without_skills)
    def shaman_cheese_ratio = normal_ratio(shaman_cheese)
    def cheese_gathered_ratio = normal_ratio(cheese_gathered)
    def firsts_ratio = normal_ratio(firsts)
    def bootcamp_ratio = normal_ratio(bootcamp)

    # Survivor ratios
    def survivor_mice_killed_ratio = survivor_ratio(survivor_mice_killed)
    def survivor_shaman_rounds_ratio = survivor_ratio(survivor_shaman_rounds)
    def survivor_survived_rounds_ratio = survivor_ratio(survivor_survived_rounds)

    # Racing ratios
    def racing_finished_maps_ratio = racing_ratio(racing_finished_maps)
    def racing_firsts_ratio = racing_ratio(racing_firsts)
    def racing_podiums_ratio = racing_ratio(racing_podiums)

    # Defilante ratios
    def defilante_finished_maps_ratio = defilante_ratio(defilante_finished_maps)
    def defilante_points_ratio = defilante_ratio(defilante_points)

    private

    def normal_ratio(stat) = stat.to_f / rounds_played
    def survivor_ratio(stat) = stat.to_f / survivor_rounds_played
    def racing_ratio(stat) = stat.to_f / racing_rounds_played
    def defilante_ratio(stat) = stat.to_f / defilante_rounds_played
  end
end
