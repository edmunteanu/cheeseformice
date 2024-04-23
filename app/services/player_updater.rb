# frozen_string_literal: true

class PlayerUpdater < MultithreadedMutator
  include Utils::PlayerMapper

  MIN_CHEESE_GATHERED = 1000

  private

  def records
    A801::Player.where(updatedLast7days: true, cheese_gathered: MIN_CHEESE_GATHERED..)
  end

  def handle_record(a801_player)
    Player.find_or_initialize_by(a801_id: a801_player.id).tap do |player|
      player.assign_attributes(map_player(a801_player))
      player.save! if player.new_record? || player.changed?
    end
  end
end
