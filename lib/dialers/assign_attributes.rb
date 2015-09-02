module Dialers
  module AssignAttributes
    # Assign the attributes hash into the object calling attribute writers of the object
    # if the object can respond to them.
    #
    # @param object [Object] any object with some or no attribute writers.
    # @param attributes [Hash<Symbol, Object>] the attributes using symbols and objects.
    #
    # @return [Object] the same object passed as parameter.
    def self.call(object, attributes)
      attributes.each do |key, value|
        writer = "#{key}=".to_sym
        if object.respond_to?(writer)
          object.public_send(writer, value)
        end
      end
      object
    end
  end
end
