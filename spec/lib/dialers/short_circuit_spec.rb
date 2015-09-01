require "dialers/short_circuit"

describe Dialers::ShortCircuit do
  let(:condition) { -> (_) { true } }
  let(:action) { -> (_) { "stop" } }
  let(:circuit) { described_class.new(condition, action) }
  let(:response) { double }

  describe "#can_stop?" do
    it "calls the condition" do
      expect(circuit.can_stop?(response)).to eq(true)
    end
  end

  describe "#stop" do
    it "calls the action" do
      expect(circuit.stop(response)).to eq("stop")
    end
  end
end
