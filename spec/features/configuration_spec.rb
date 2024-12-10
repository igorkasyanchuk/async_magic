require "support/environment"

RSpec.describe "AsyncMagic Configuration" do
  let(:post) { Post.create!(title: "Test Post") }

  context "when included in ActiveRecord::Base by default" do
    before do
      AsyncMagic.configure do |config|
        config.include_in = :active_record
      end
    end

    it "allows async methods in models" do
      future = post.expensive_operation
      expect(future).to be_a(Concurrent::Future)
      expect(future.value).to eq("Done")
    end

    it "does not affect non-async methods" do
      expect(post.normal_method).to eq("normal result")
    end
  end
end
