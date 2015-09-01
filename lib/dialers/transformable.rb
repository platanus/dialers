module Dialers
  class Transformable
    def initialize(response)
      self.response = response
      self.raw_data = response.body
    end

    def transform_to_one(entity_class_or_decider, root: nil)
      object = root ? raw_data[root] : raw_data
      transform_attributes_to_object(entity_class_or_decider, object)
    end

    def transform_to_many(entity_class_or_decider, root: nil)
      items = get_rooted_items(root)
      unless items.is_a?(Array)
        fail Dialers::ImpossibleTranformationError, response
      end
      items.map { |item| transform_attributes_to_object(entity_class_or_decider, item) }
    end

    def as_received
      raw_data
    end

    private

    attr_accessor :raw_data, :response

    def transform_attributes_to_object(entity_class_or_decider, attributes)
      entity_class = decide_entity_class(entity_class_or_decider)
      if entity_class.nil?
        fail Dialers::ResponseError, response
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
