# frozen_string_literal: true

module PlayerCalculators
  module Level
    def current_level
      current_level_and_experience[:current_level]
    end

    def current_experience
      current_level_and_experience[:current_experience]
    end

    private

    def current_level_and_experience
      level = 0
      experience_left = experience

      while experience_left >= experience_needed(level)
        experience_left -= experience_needed(level)
        level += 1
      end

      { current_level: level, current_experience: experience_left }
    end

    def experience_needed(level)
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
