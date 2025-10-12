class PlayerUpdateService
  include Utils::PlayerMapper

  def initialize(batch_size: ENV.fetch("UPDATER_BATCH_SIZE", 1000).to_i)
    @batch_size = batch_size
  end

  MAX_POOL_SIZE = 9
  def call
    records.in_batches(of: @batch_size) do |batch|
      threads = []
      pool_size = [ ActiveRecord::Base.connection_pool.size - 1, MAX_POOL_SIZE ].min
      slice_size = batch.count < pool_size ? batch.count : (batch.count / pool_size.to_f).ceil

      start_threads(threads, batch, slice_size)

      threads.each(&:join)
    end
  end

  private

  MIN_CHEESE_GATHERED = 250
  def records
    A801::Player.where(cheese_gathered: MIN_CHEESE_GATHERED..)
  end
  # THIS IS THE DEFAULT CRITERIA – UNCOMMENT AFTER COPYING ALL PLAYERS
  # MIN_CHEESE_GATHERED = 250
  # def records
  #   A801::Player.where(updatedLast7days: true, cheese_gathered: MIN_CHEESE_GATHERED..)
  # end

  def start_threads(threads, batch, slice_size)
    batch.each_slice(slice_size) do |slice|
      threads << Thread.new { slice.each { |record| handle_record(record) } }
    end
  end

  def handle_record(a801_player)
    Player.find_or_initialize_by(a801_id: a801_player.id).tap do |player|
      player.assign_attributes(map_player(a801_player))
      player.save! if player.new_record? || player.changed?
    end
  end
end
