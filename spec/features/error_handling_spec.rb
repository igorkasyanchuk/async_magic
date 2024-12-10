require "support/environment"

RSpec.describe "AsyncMagic Error Handling" do
  let(:post) { Post.create!(title: "Test Post") }

  before do
    AsyncMagic.configure do |config|
      config.include_in = :active_record
    end
  end

  it "logs errors and re-raises them" do
    expect {
      post.failing_async_method.value!
    }.to raise_error(RuntimeError, "Something went wrong")
  end
end
