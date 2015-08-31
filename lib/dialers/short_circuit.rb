module Dialers
  class ShortCircuit
    def initialize(condition, action)
      self.condition = condition
      self.action = action
    end

    def can_stop?(response)
      condition.call(response)
    end

    def stop(response)
      action.call(response)
    end

    attr_accessor :condition, :action
  end
end
