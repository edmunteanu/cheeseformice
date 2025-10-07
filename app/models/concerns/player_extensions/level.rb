# frozen_string_literal: true

module PlayerExtensions
  module Level
    def current_level
      current_level_and_experience[:current_level]
    end

    def current_experience
      current_level_and_experience[:current_experience]
    end

    def experience_needed
      experience_needed_for(current_level)
    end

    def level_progress
      current_experience.to_f / experience_needed
    end

    private

    def current_level_and_experience
      @current_level_and_experience ||= calculate_level_and_experience
    end

    def calculate_level_and_experience
      level = 0
      experience_left = experience

      loop do
        experience_needed = experience_needed_for(level)

        break if experience_left < experience_needed

        experience_left -= experience_needed
        level += 1
      end

      { current_level: level, current_experience: experience_left }
    end

    def experience_needed_for(level)
      return 0 if level.zero?

      experience = 32

      experience += sum_experience(level, factor: 2, tier_from: 2, tier_to: 29) if level >= 2
      experience += sum_experience(level, factor: 10, tier_from: 30, tier_to: 59) if level >= 30
      experience += sum_experience(level, factor: 15, tier_from: 60) if level >= 60

      experience
    end

    def sum_experience(level, factor:, tier_from:, tier_to: nil)
      level_amount = [ level, tier_to ].compact.min - tier_from + 1
      level_sum = [ level, tier_to ].compact.min + tier_from
      factor * level_amount * level_sum / 2
    end
  end
end
