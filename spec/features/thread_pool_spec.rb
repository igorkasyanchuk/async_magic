require "support/environment"

RSpec.describe "AsyncMagic Thread Pool Configuration" do
  let(:post) { Post.create!(title: "Test Post") }

  before do
    AsyncMagic.configure do |config|
      config.include_in = :active_record
      config.executor_options = {
        min_threads: 5,
        max_threads: 10,
        auto_terminate: true,
        idletime: 30,
        max_queue: 0,
        fallback_policy: :caller_runs
      }
    end
  end

  it "rebuilds the thread pool with new settings" do
    future = post.expensive_operation
    expect(future.value).to eq("Done")
  end
end
