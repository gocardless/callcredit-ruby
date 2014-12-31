module Callcredit
  module Checks
    class BankStandard
      REQUIRED_INPUTS = [:account_number, :sort_code]

      def initialize(client)
        @client = client
      end

      def perform(data = {})
        check_params(data)
        response = @client.perform_check(:bank_standard, bank_data: data)
        @client.config[:raw] ? response : Response.new(response)
      end

      private

      def check_params(data)
        REQUIRED_INPUTS.each do |param|
          if data[param].nil?
            msg = "An BankStandard check requires a #{param}"
            raise InvalidRequestError.new(msg, param)
          end
        end
      end
    end
  end
end
