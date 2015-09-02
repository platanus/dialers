module Dialers
  # This class is just a convenience to this:
  #
  #   class Anything
  #     def api_caller
  #       @api_caller ||= ApiCaller.new
  #     end
  #   end
  #
  # Instead, you can wrap it like this:
  #
  #   class Anything < Dialers::Wrapper
  #     api_caller { ApiCaller.new }
  #   end
  #
  # The major reason of the existence of this class is to provide a place to add future
  # improvements like automatic injection of callers within Rails based on conventions and
  # methods and patterns that may arise in the future.
  #
  class Wrapper
    # Defines the api caller instance to use on all wrappers.
    #
    #   api_caller { ApiCaller.new }
    #
    def self.api_caller(&block)
      define_method(:api_caller) do
        @api_caller ||= block.call
      end
    end

    # Returns the value of the `api_caller` as defined by the {api_caller} class method
    attr_reader :api_caller
  end
end
