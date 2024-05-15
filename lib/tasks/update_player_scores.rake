# frozen_string_literal: true

# require Rails.root.join('app/services/utils/player_mapper')

namespace :players do
  desc 'Manually update player scores'
  task update_scores: :environment do
    Player.in_batches.each_with_index do |batch, batch_index|
      puts "Processing batch #{batch_index + 1}"

      threads = []
      pool_size = [ActiveRecord::Base.connection_pool.size - 1, PlayerUpdateService::MAX_POOL_SIZE].min
      slice_size = batch.count < pool_size ? batch.count : (batch.count / pool_size.to_f).ceil

      batch.each_slice(slice_size) do |slice|
        threads << Thread.new do
          slice.each do |player|
            player.update!(updated_at: Time.current) # Trigger callbacks
          end
        end
      end

      threads.each(&:join)
    end
  end
end
