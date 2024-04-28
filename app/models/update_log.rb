# frozen_string_literal: true

class UpdateLog < ApplicationRecord
  enum status: { started: 'started', updating_players: 'updating_players', updating_ranks: 'updating_ranks',
                 finished: 'finished' }
end
