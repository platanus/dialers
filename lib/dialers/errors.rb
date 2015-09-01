module Dialers
  class UnreachableError < StandardError
  end

  class ParsingError < StandardError
  end

  class ResponseError < StandardError
  end

  class InexistentApiError < StandardError
  end

  class ServerError < StandardError
  end

  class NotFoundError < StandardError
  end

  class UnauthorizedError < StandardError
  end

  class ImpossibleTranformationError < StandardError
  end

  ERRORS = [
    UnreachableError, ParsingError, ResponseError, InexistentApiError
  ]
end
