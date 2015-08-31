module Dialers
  class ShortCircuitsCollection
    ResponseLambda = -> (_response) { nil }

    def initialize
      self.collection = []
    end

    def add(options)
      collection << Dialers::ShortCircuit.new(options.fetch(:if), options.fetch(:do))
    end

    def search_for_stops(response)
      short_circuit = collection.find do |item|
        item.can_stop?(response)
      end

      if !short_circuit.nil?
        short_circuit.stop(response)
      end
    end

    private

    attr_accessor :collection
  end
end
