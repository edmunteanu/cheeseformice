# frozen_string_literal: true

class PlayerImporter < MultithreadedMutator
  include Utils::PlayerMapper

  MIN_CHEESE_GATHERED = 1000

  private

  def records
    A801::Player.where(cheese_gathered: MIN_CHEESE_GATHERED..)
  end

  def handle_record(a801_player)
    Player.find_or_initialize_by(a801_id: a801_player.id).tap do |player|
      break unless player.new_record?

      player.assign_attributes(map_player(a801_player))
      player.save!
    end
  end
end
