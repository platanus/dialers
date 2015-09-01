require "dialers/assign_attributes"
require "dialers/errors"
require "dialers/transformable"

describe Dialers::Transformable do
  let(:body) { { a: "a", b: "b" } }
  let(:status) { 200 }
  let(:response) { double(status: status, body: body) }
  let(:transformable) { described_class.new(response) }
  let(:stuff_class) { Class.new { attr_accessor :a, :b } }
  let(:other_stuff_class) { Class.new { attr_accessor :c, :d } }

  describe "#as_received" do
    it "just returns the body parsed" do
      expect(transformable.as_received).to eq(body)
    end
  end

  describe "#transform_to_one" do
    context "with a class" do
      it "returns an instance of that class" do
        stuff = transformable.transform_to_one(stuff_class)
        expect(stuff.class).to eq(stuff_class)
        expect(stuff.a).to eq("a")
        expect(stuff.b).to eq("b")
      end
    end

    context "with a decider hash" do
      let(:decider) do
        { 201 => stuff_class, 202 => other_stuff_class }
      end

      context "with one status" do
        let(:status) { 201 }
        let(:body) { { a: "a", b: "b" } }

        it "returns an instance of that class" do
          stuff = transformable.transform_to_one(decider)
          expect(stuff.class).to eq(stuff_class)
          expect(stuff.a).to eq("a")
          expect(stuff.b).to eq("b")
        end
      end

      context "with the other" do
        let(:status) { 202 }
        let(:body) { { c: "c", d: "d" } }

        it "returns an instance of that class" do
          other_stuff = transformable.transform_to_one(decider)
          expect(other_stuff.class).to eq(other_stuff_class)
          expect(other_stuff.c).to eq("c")
          expect(other_stuff.d).to eq("d")
        end
      end
    end
  end

  describe "#transform_to_many" do
    context "with root" do
      let(:result) do
        transformable.transform_to_many(stuff_class, root: "root")
      end

      context "when the body has a root" do
        let(:body) do
          { "root" => [{ a: "a", b: "b" }] }
        end

        it "returns an array of the object to transform from the root" do
          expect(result.size).to eq(1)
          expect(result.first.class).to eq(stuff_class)
        end

        context "but the body is not an array" do
          let(:body) do
            { "root" => { a: "a", b: "b" } }
          end

          it "raises an ImpossibleTranformationError" do
            expect { result }.to raise_error(Dialers::ImpossibleTranformationError)
          end
        end
      end

      context "when the body has no root" do
        let(:body) { [{ a: "a", b: "b" }] }

        it "returns an array of the object to transform" do
          expect(result.size).to eq(1)
          expect(result.first.class).to eq(stuff_class)
        end
      end
    end

    context "without root" do
      let(:body) { [{ a: "a", b: "b" }] }

      it "returns an array of the object to transform" do
        stuff = transformable.transform_to_many(stuff_class)
        expect(stuff.size).to eq(1)
        expect(stuff.first.class).to eq(stuff_class)
      end
    end
  end
end
