require "concurrent"
require "logger"
require "active_support/concern"

module AsyncMagic
  extend ActiveSupport::Concern

  DEFAULT_EXECUTOR_OPTIONS = {
    min_threads: 10,
    max_threads: 50,
    auto_terminate: true,
    idletime: 60, # 1 minute
    max_queue: 0, # unlimited
    fallback_policy: :caller_runs
  }.freeze

  THREAD_POOL = Concurrent::ThreadPoolExecutor.new(DEFAULT_EXECUTOR_OPTIONS)

  ASYNC_LOGGER = Logger.new($stdout)
  ASYNC_LOGGER.level = Logger::ERROR

  included do
    class_attribute :async_methods_list, instance_accessor: false, default: Set.new
    class_attribute :async_class_methods_list, instance_accessor: false, default: Set.new
  end

  module ClassMethods
    def async
      @async_next_method = true
    end

    def singleton_method_added(method_name)
      super
      if defined?(@async_next_method) && @async_next_method
        @async_next_method = false

        original_method = method(method_name)
        define_singleton_method(method_name) do |*args, &block|
          future = Concurrent::Future.execute(executor: THREAD_POOL) do
            original_method.call(*args, &block)
          rescue => e
            ASYNC_LOGGER.error("Async class method #{method_name} failed: #{e.message}")
            ASYNC_LOGGER.error(e.backtrace.join("\n"))
            raise e
          end
          future
        end

        async_class_methods_list << method_name
      end
    end

    def method_added(method_name)
      super
      if defined?(@async_next_method) && @async_next_method
        @async_next_method = false

        original_method = instance_method(method_name)
        define_method(method_name) do |*args, &block|
          future = Concurrent::Future.execute(executor: THREAD_POOL) do
            original_method.bind_call(self, *args, &block)
          rescue => e
            ASYNC_LOGGER.error("Async method #{method_name} failed: #{e.message}")
            ASYNC_LOGGER.error(e.backtrace.join("\n"))
            raise e
          end
          future
        end

        async_methods_list << method_name
      end
    end
  end

  def self.shutdown
    THREAD_POOL.shutdown
    THREAD_POOL.wait_for_termination(5) # Wait up to 5s
  end
end
