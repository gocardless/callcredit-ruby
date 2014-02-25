module Callcredit
  module Middleware
    class CheckResponse < Faraday::Middleware
      def call(env)
        @app.call(env).on_complete do |env|
          unless results = env[:body]["Results"]
            raise InvalidResponseError.new(
              "Invalid response", env[:status], env)
          end

          if results["Errors"]
            errors = results["Errors"].values.flatten
            messages = errors.map { |e| e.is_a?(Hash) ? e["__content__"] : e }
            raise APIError.new(messages.join(" | "), env[:status], env)
          end
          response_values(env)
        end
      end

      def response_values(env)
        { status: env[:status], headers: env[:headers], body: env[:body] }
      end
    end

    Faraday.register_middleware :response, check_response: CheckResponse
  end
end