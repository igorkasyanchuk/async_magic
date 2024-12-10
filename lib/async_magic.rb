require "async_magic/version"
require "async_magic/async"
require "async_magic/railtie" if defined?(Rails)

module AsyncMagic
  mattr_accessor :executor_options, default: DEFAULT_EXECUTOR_OPTIONS
  mattr_accessor :include_in, default: :global

  def self.configure
    yield self
    rebuild_executor
  end

  def self.rebuild_executor
    THREAD_POOL.shutdown
    THREAD_POOL.wait_for_termination(5)
    AsyncMagic.send(:remove_const, :THREAD_POOL) if AsyncMagic.const_defined?(:THREAD_POOL)
    AsyncMagic.const_set(
      :THREAD_POOL,
      Concurrent::ThreadPoolExecutor.new(executor_options)
    )
  end
end
