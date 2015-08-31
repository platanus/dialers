require "dialers/status"

RSpec.describe Dialers::Status do
  def status(code)
    described_class.new(code)
  end

  describe "#is?" do
    it("is true if the status is the argument passed") { expect(status(201).is?(201)).to eq(true) }
    it("is false otherwise") { expect(status(201).is?(200)).to eq(false) }
  end

  describe "#success?" do
    it("is true if it's 2xx") { expect(status(202).success?).to eq(true) }
    it("is false otherwise") { expect(status(300).success?).to eq(false) }
  end

  describe "#redirect?" do
    it("is true if it's 3xx") { expect(status(304).redirect?).to eq(true) }
    it("is false otherwise") { expect(status(201).redirect?).to eq(false) }
  end

  describe "#client_error?" do
    it("is true if it's 4xx") { expect(status(404).client_error?).to eq(true) }
    it("is false otherwise") { expect(status(500).client_error?).to eq(false) }
  end

  describe "#server_error?" do
    it("is true if it's 5xx") { expect(status(502).server_error?).to eq(true) }
    it("is false otherwise") { expect(status(401).server_error?).to eq(false) }
  end
end
