module Verbalizeit
  module Error
    class UnknownEnvironment < StandardError
    end

    class Unauthorized < StandardError
    end

    class BadRequest < StandardError
    end
  end
end