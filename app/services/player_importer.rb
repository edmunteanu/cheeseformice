# frozen_string_literal: true

# This service does not really need proper error handling in case of errors raised while communicating with the
# A801 database, as it is mainly a manually triggered task.
class PlayerImporter
  MIN_CHEESE_GATHERED = 1000
  MAX_POOL_SIZE = 9

  class << self
    include Utils::PlayerMapper

    def call
      A801::Player.where(cheese_gathered: MIN_CHEESE_GATHERED..).in_batches do |batch|
        threads = []
        pool_size = [ActiveRecord::Base.connection_pool.size - 1, MAX_POOL_SIZE].min
        slice_size = batch.count < pool_size ? batch.count : (batch.count / pool_size.to_f).ceil

        start_threads(threads, batch, slice_size)

        threads.each(&:join)
      end
    end

    private

    def start_threads(threads, batch, slice_size)
      batch.each_slice(slice_size) do |slice|
        threads << Thread.new { slice.each { |a801_player| import_player(a801_player) } }
      end
    end

    def import_player(a801_player)
      Player.find_or_initialize_by(a801_id: a801_player.id).tap do |player|
        break unless player.new_record?

        player.assign_attributes(map_player(a801_player))
        player.save!
      end
    end
  end
end
