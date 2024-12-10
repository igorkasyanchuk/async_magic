require "support/environment"

RSpec.describe "AsyncMagic for Class Methods" do
  before do
    AsyncMagic.configure do |config|
      config.include_in = :active_record
    end
  end

  it "executes class methods asynchronously" do
    future = Post.class_async_method
    expect(future).to be_a(Concurrent::Future)
    expect(future.value).to eq("Class method completed")
  end

  it "logs errors and re-raises them for class methods" do
    expect {
      Post.failing_class_method.value!
    }.to raise_error(RuntimeError, "Something went wrong")
  end
end
