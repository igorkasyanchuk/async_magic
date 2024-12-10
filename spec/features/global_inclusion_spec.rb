require "support/environment"

RSpec.describe "AsyncMagic Global Inclusion" do
  before do
    Object.send(:include, AsyncMagic)
  end

  it "makes async available everywhere" do
    class GlobalClass # rubocop:disable Lint/ConstantDefinitionInBlock
      async
      def global_async_method
        "global result"
      end
    end

    future = GlobalClass.new.global_async_method
    expect(future.value).to eq("global result")
  end
end
