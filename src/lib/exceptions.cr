module Crul
  class SomethingWrong < Exception
    def initialize(message)
      super message
    end
  end

  class CallError < Exception
    def initialize(f, result, message, desc)
      super "Curl API error (#{f}): #{result} #{message} - #{desc}"
    end
  end
end
