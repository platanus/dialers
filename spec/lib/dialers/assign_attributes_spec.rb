require "dialers/assign_attributes"

describe Dialers::AssignAttributes do
  let(:klass) do
    Class.new do
      attr_accessor :a, :b, :c
    end
  end

  let(:object) { klass.new }

  it "assigns the attributes of a hash to an object using attr_writers" do
    described_class.call(object, a: 1, b: 2, c: 3)
    expect(object.a).to eq(1)
    expect(object.b).to eq(2)
    expect(object.c).to eq(3)
  end
end
