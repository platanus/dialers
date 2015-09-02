module Dialers
  # A wrapper over an HTTP status to answer some questions related to what a state means.
  class Status
    def initialize(status)
      self.status = status
    end

    # @param code [Fixnum] The code to compare
    # @return [Boolean] wether the status is the argument
    def is?(code)
      status.to_i == code.to_i
    end

    # @return [Boolean] wether the status is a 2xx one.
    def success?
      initial_letter == "2"
    end

    # @return [Boolean] wether the status is a 3xx one.
    def redirect?
      initial_letter == "3"
    end

    # @return [Boolean] wether the status is a 4xx one.
    def client_error?
      initial_letter == "4"
    end

    # @return [Boolean] wether the status is a 5xx one.
    def server_error?
      initial_letter == "5"
    end

    # @return [Boolean] wether the status is 200.
    def ok?
      is?(200)
    end

    # @return [Boolean] wether the status is 201.
    def created?
      is?(201)
    end

    # @return [Boolean] wether the status is 202.
    def accepted?
      is?(202)
    end

    # @return [Boolean] wether the status is 204.
    def no_content?
      is?(204)
    end

    # @return [Boolean] wether the status is 400.
    def bad_request?
      is?(400)
    end

    # @return [Boolean] wether the status is 401.
    def unauthorized?
      is?(401)
    end

    # @return [Boolean] wether the status is 404.
    def not_found?
      is?(404)
    end

    # @return [Boolean] wether the status is 405.
    def method_not_allowed?
      is?(405)
    end

    private

    def initial_letter
      @initial_letter ||= status.to_s[0]
    end

    attr_accessor :status
  end
end
