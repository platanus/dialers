module Dialers
  class Status
    def initialize(status)
      self.status = status
    end

    define_method(:is?) { |code| status.to_i == code.to_i }
    define_method(:success?) { initial_letter == "2" }
    define_method(:redirect?) { initial_letter == "3" }
    define_method(:client_error?) { initial_letter == "4" }
    define_method(:server_error?) { initial_letter == "5" }
    define_method(:ok?) { is?(200) }
    define_method(:created?) { is?(201) }
    define_method(:accepted?) { is?(202) }
    define_method(:no_content?) { is?(204) }
    define_method(:bad_request?) { is?(400) }
    define_method(:unauthorized?) { is?(401) }
    define_method(:not_found?) { is?(404) }
    define_method(:method_not_allowed?) { is?(405) }

    def initial_letter
      @initial_letter ||= status.to_s[0]
    end

    private

    attr_accessor :status
  end
end
