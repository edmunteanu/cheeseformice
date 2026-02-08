# This Rake task allows you to manually trigger the update of all player stats by iterating through the
# players in batches and synchronizing their statistics with the API data. Due to how `Player#log_changes`
# is implemented, if there is already a change log for a given player, the log will simply be updated with
# the new deltas instead of creating a new log entry.
namespace :players do
  desc "Synchronize all local players with the API"
  task update_stats: :environment do
    puts "Starting full player synchronization..."

    class PlayerSynchronizer
      include Utils::PlayerMapper

      def sync(player)
        external_player = A801::Player.find(player.a801_id)
        return unless external_player

        player.update!(map_player(external_player))
      rescue StandardError => e
        warn "Failed to sync player '#{player.name} (#{player.a801_id})': #{e.message}"
      end
    end

    synchronizer = PlayerSynchronizer.new
    db_pool_size = ActiveRecord::Base.connection_pool.size
    concurrency = [ db_pool_size - 1, 5 ].min

    puts "Concurrency: #{concurrency} threads"

    Player.in_batches(of: 1000).each_with_index do |batch, batch_index|
      puts "Processing batch #{batch_index + 1}..."

      players = batch.to_a
      threads = []
      slice_size = (players.size / concurrency.to_f).ceil

      players.each_slice(slice_size) do |slice|
        threads << Thread.new do
          ActiveRecord::Base.connection_pool.with_connection do
            slice.each do |player|
              synchronizer.sync(player)
            end
          end
        end
      end

      threads.each(&:join)
    end

    puts "Synchronization complete."
  end
end
