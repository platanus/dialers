require "dialers/wrapper"

describe Dialers::Wrapper do
  let(:subclass) { Class.new(described_class) }
  let(:api_caller) { double }

  describe ".api_caller" do
    it "defines an api_caller method on instances to return an object" do
      instance = subclass.new
      expect(instance.api_caller).to be_nil
      subclass.api_caller { api_caller }
      expect(instance.api_caller).to eq(api_caller)
      subclass.api_caller { nil }
      expect(instance.api_caller).to eq(api_caller)
    end
  end
end
