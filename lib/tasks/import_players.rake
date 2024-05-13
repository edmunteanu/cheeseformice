# frozen_string_literal: true

# require Rails.root.join('app/services/utils/player_mapper')

namespace :players do
  desc 'Normalize all player names in the database'
  task import: :environment do
    include Utils::PlayerMapper

    A801::Player.where(cheese_gathered: ...1000, bootcamp: 250..).in_batches.each_with_index do |batch, batch_index|
      puts "Processing batch #{batch_index + 1}"
      threads = []
      pool_size = [ActiveRecord::Base.connection_pool.size - 1, PlayerUpdater::MAX_POOL_SIZE].min
      slice_size = batch.count < pool_size ? batch.count : (batch.count / pool_size.to_f).ceil

      batch.each_slice(slice_size) do |slice|
        threads << Thread.new do
          slice.each do |a801_player|
            Player.find_or_initialize_by(a801_id: a801_player.id).tap do |player|
              break unless player.new_record?

              player.assign_attributes(map_player(a801_player))
              player.save!
            end
          end
        end
      end

      threads.each(&:join)
    end
  end
end
