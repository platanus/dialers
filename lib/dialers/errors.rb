module Dialers
  class ErrorAsErrorProxy < StandardError
    def initialize(error = nil)
      self.error = error
    end

    def message
      error ? error.message : super
    end

    private

    attr_accessor :error
  end

  class ErrorWithResponse < StandardError
    def initialize(response = nil)
      self.response = response
    end

    def message
      if response.nil?
        super
      else
        "\n
        STATUS: #{response.status}
        URL: #{response.env.url}
        REQUEST HEADERS: #{response.env.request_headers}
        HEADERS: #{response.env.response_headers}
        BODY: #{response.body}\n\n"
      end
    end

    private

    attr_accessor :response
  end

  class UnreachableError < ErrorAsErrorProxy
  end

  class ParsingError < ErrorAsErrorProxy
  end

  class ResponseError < ErrorWithResponse
  end

  class InexistentApiError < StandardError
    def initialize(searched_class)
      self.searched_class = searched_class
    end

    def message
      "\n\nSEARCHED CLASS: #{searched_class}\n\n"
    end

    private

    attr_accessor :searched_class
  end

  class ServerError < ErrorWithResponse
  end

  class NotFoundError < ErrorWithResponse
  end

  class UnauthorizedError < ErrorWithResponse
  end

  class ImpossibleTranformationError < ErrorWithResponse
  end

  ERRORS = [
    UnreachableError, ParsingError, ResponseError, InexistentApiError
  ]
end
