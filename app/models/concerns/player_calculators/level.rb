# frozen_string_literal: true

module PlayerCalculators
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
      level = 0
      experience_left = experience

      while experience_left >= experience_needed_for(level)
        experience_left -= experience_needed_for(level)
        level += 1
      end

      { current_level: level, current_experience: experience_left }
    end

    def experience_needed_for(level)
      return 0 if level.zero?

      experience = 32

      (2..level).each do |l|
        experience += 2 * l if l.between?(2, 29)
        experience += 10 * l if l.between?(30, 59)
        experience += 15 * l if l >= 60
      end

      experience
    end
  end
end
