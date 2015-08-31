module Dialers
  class Wrapper
    def self.api_caller(&block)
      define_method(:api_caller) do
        @api_caller ||= block.call
      end
    end

    attr_reader :api_caller
  end
end
