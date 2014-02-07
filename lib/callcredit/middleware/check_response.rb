module Callcredit
  module Middleware
    class CheckResponse < Faraday::Middleware
      def call(env)
        @app.call(env).on_complete do |env|
          unless results = env[:body]["Results"]
            raise APIError.new("Received unexpected XML (Results tag missing)")
          end

          if results["Errors"]
            errors = results["Errors"].values.flatten
            message = errors.map { |e| e["__content__"] }.join(" | ")
            raise APIError.new(message, env[:status], env)
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