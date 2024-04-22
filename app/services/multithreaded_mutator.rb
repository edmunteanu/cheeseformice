# frozen_string_literal: true

class MultithreadedMutator
  MAX_POOL_SIZE = 9

  class << self
    def call
      records.in_batches do |batch|
        threads = []
        pool_size = [ActiveRecord::Base.connection_pool.size - 1, MAX_POOL_SIZE].min
        slice_size = batch.count < pool_size ? batch.count : (batch.count / pool_size.to_f).ceil

        start_threads(threads, batch, slice_size)

        threads.each(&:join)
      end
    end

    private

    # :nocov:
    def records
      raise NotImplementedError, 'This method must be implemented in a subclass'
    end
    # :nocov:

    def start_threads(threads, batch, slice_size)
      batch.each_slice(slice_size) do |slice|
        threads << Thread.new { slice.each { |record| handle_record(record) } }
      end
    end

    # :nocov:
    def handle_record(record)
      raise NotImplementedError, 'This method must be implemented in a subclass'
    end
    # :nocov:
  end
end
