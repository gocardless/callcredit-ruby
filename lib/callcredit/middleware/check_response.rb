module Callcredit
  module Middleware
    class CheckResponse < Faraday::Middleware
      def call(env)
        @app.call(env).on_complete do |completed_env|
          results = completed_env[:body]["Results"]

          unless results
            raise InvalidResponseError.new(
              "Invalid response", completed_env[:status], completed_env)
          end

          if results["Errors"]
            errors = results["Errors"].values.flatten
            messages = errors.map { |e| e.is_a?(Hash) ? e["__content__"] : e }

            raise APIError.new(messages.join(" | "), completed_env[:status],
                               completed_env)
          end
          response_values(completed_env)
        end
      end

      def response_values(env)
        { status: env[:status], headers: env[:headers], body: env[:body] }
      end
    end

    Faraday::Response.register_middleware check_response: CheckResponse
  end
end
