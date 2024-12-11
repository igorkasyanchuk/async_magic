require "support/environment"

RSpec.describe HomeController, type: :request do
  it "creates a visit" do
    10.times do
      get "/"
    end
    expect(Visit.count).to be < 10
    sleep 3
    expect(Visit.count).to eq(10)
  end
end
