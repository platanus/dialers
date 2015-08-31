module Dialers
  module AssignAttributes
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
