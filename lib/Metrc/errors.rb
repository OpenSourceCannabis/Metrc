module Metrc
  module Errors
    class MissingConfiguration < RuntimeError; end
    class MissingParameter < RuntimeError; end
    class RequestError < RuntimeError; end

    class BadRequest < RequestError; end
    class Unauthorized < RequestError; end
    class Forbidden < RequestError; end
    class NotFound < RequestError; end
    class TooManyRequests < RequestError; end
    class InternalServerError < RequestError; end

    class << self
      def parse_request_errors(response:)
        body = response.parsed_response
        if body.is_a? Array
          consolidate_errors_by_row(body).join(', ')
        elsif body.is_a? Hash
          body['Message']
        end
      end

      private

      def consolidate_errors_by_row(array)
        array.reduce({}) do |errors, row|
          index = row['row']
          if errors[index]
            errors[index] += ", #{row["message"]}"
          else
            errors[index] = row['message']
          end
          errors
        end.map do |index, message|
          "#{index}: #{message}"
        end
      end
    end
  end
end
