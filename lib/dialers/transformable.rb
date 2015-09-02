module Dialers
  # This class provide some ways to transform a reponse into an object or a set of objects
  # based on what objects the user of this class wants to provide.
  class Transformable
    def initialize(response)
      self.response = response
      self.raw_data = response.body
    end

    # Transforms a response into one object based on the response's body.
    #
    # If you pass a hash like this:
    #
    #   { 200 => ProductCreated, 202 => ProductAccepted }
    #
    # the transformation will decide which object to create based on the status.
    #
    # It's important to note that the class must provide attribute writers for this method to be
    # able to fill an object with the responses's body data.
    #
    # @param entity_class_or_decider [Hash, Class] A class or a hash of Fixnum => Class
    #   to decide with the status.
    # @param root [String, nil] The root to use to get the object from the body.
    #
    # @return [Object] The result of the transformation.
    def transform_to_one(entity_class_or_decider, root: nil)
      object = root ? raw_data[root] : raw_data
      transform_attributes_to_object(entity_class_or_decider, object)
    end

    # Transforms a response into many objects based on the response's body.
    #
    # @param entity_class_or_decider [Hash, Class] A class or a hash of Fixnum => Class
    #   to decide with the status.
    # @param root [String, nil] The root to use to get an array from the body.
    #
    # @return [Array<Object>] The result of the transformation.
    def transform_to_many(entity_class_or_decider, root: nil)
      items = get_rooted_items(root)
      unless items.is_a?(Array)
        fail Dialers::ImpossibleTranformationError.new(response)
      end
      items.map { |item| transform_attributes_to_object(entity_class_or_decider, item) }
    end

    # Returns the raw body of the request.
    # @return [Hash, Array] the raw body of the request.
    def as_received
      raw_data
    end

    private

    attr_accessor :raw_data, :response

    def transform_attributes_to_object(entity_class_or_decider, attributes)
      entity_class = decide_entity_class(entity_class_or_decider)
      if entity_class.nil?
        fail Dialers::ResponseError.new(response)
      else
        Dialers::AssignAttributes.call(entity_class.new, attributes)
      end
    end

    def decide_entity_class(entity_class_or_decider)
      case entity_class_or_decider
      when Class
        entity_class_or_decider
      when Hash
        entity_class_or_decider[response.status]
      end
    end

    def get_rooted_items(root)
      if root.nil?
        raw_data
      elsif raw_data.is_a?(Array)
        raw_data
      else
        raw_data[root]
      end
    end
  end
end
