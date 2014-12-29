module Verbalizeit
  module Error
    class UnknownEnvironment < StandardError
    end

    class Unauthorized < StandardError
    end

    class BadRequest < StandardError
    end

    class NotImplemented < StandardError
    end

    class Forbidden < StandardError
    end

    class NotFound < StandardError
    end
  end
end