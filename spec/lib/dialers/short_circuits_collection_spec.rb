require "dialers/short_circuit"
require "dialers/short_circuits_collection"

describe Dialers::ShortCircuitsCollection do
  let(:collection) { described_class.new }

  describe "#search_for_stops" do
    before do
      collection.add if: -> (_) { false }, do: -> (_) { fail "one" }
      collection.add if: -> (_) { false }, do: -> (_) { fail "two" }
      collection.add if: -> (_) { true }, do: -> (_) { fail "three" }
      collection.add if: -> (_) { false }, do: -> (_) { fail "four" }
    end

    it "stops when some shortcircuit is true" do
      expect { collection.search_for_stops(double) }.to raise_error(StandardError, "three")
    end
  end
end
