require "support/environment"

RSpec.describe "AsyncMagic Manual Inclusion" do
  let(:post) { Post.create!(title: "Test Post") }

  before do
    # No automatic inclusion
    AsyncMagic.configure do |config|
      config.include_in = nil
    end
  end

  after do
    # Reset after test
    AsyncMagic.configure do |config|
      config.include_in = :active_record
    end
  end

  it "requires manual inclusion in models" do
    # Since include_in = nil, we must ensure Post includes AsyncMagic
    # If Post is defined in dummy app with `include AsyncMagic`, this should work.
    future = post.expensive_operation
    expect(future).to be_a(Concurrent::Future)
    expect(future.value).to eq("Done")
  end
end
