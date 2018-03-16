module Metrc
  module Errors
    class MissingConfiguration < RuntimeError; end
    class MissingParameter < RuntimeError; end
    class NotFound < RuntimeError; end
  end
end
