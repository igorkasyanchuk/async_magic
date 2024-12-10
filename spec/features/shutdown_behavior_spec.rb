require "support/environment"

RSpec.describe "AsyncMagic Shutdown Behavior" do
  it "shuts down the thread pool gracefully at exit" do
    expect(AsyncMagic::THREAD_POOL).to_not be_shutdown
    AsyncMagic.shutdown
    expect(AsyncMagic::THREAD_POOL).to be_shutdown
  end
end
