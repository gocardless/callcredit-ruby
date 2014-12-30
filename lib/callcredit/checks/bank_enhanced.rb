module Callcredit
  module Checks
    class BankEnhanced
      REQUIRED_INPUTS =    [:first_name, :last_name, :postcode, :account_number,
                            :sort_code, :account_number, :sort_code]

      PERSONAL_DATA_KEYS = [:first_name, :last_name, :postcode,
                            :building_name, :building_number]

      BANK_DATA_KEYS =     [:account_number, :sort_code]

      def initialize(client)
        @client = client
      end

      def perform(data = {})
        check_params(data)
        response = @client.perform_check([:bank_standard, :bank_enhanced], build_params(data))
        @client.config[:raw] ? response : Response.new(response)
      end

      private

      def build_params(data)
        {
          personal_data: data.select { |k,v| PERSONAL_DATA_KEYS.include?(k) },
          bank_data: data.select { |k,v| BANK_DATA_KEYS.include?(k) }
        }
      end

      def check_params(data)
        REQUIRED_INPUTS.each do |param|
          if data[param].nil?
            msg = "An BankEnhanced check requires a #{param}"
            raise InvalidRequestError.new(msg, param)
          end
        end

        # For a BankEnhanced check, we also need a building name or number
        unless data[:building_number] || data[:building_name]
          msg = "A BankEnhanced check requires a building number or name"
          raise InvalidRequestError.new(msg, :building_number)
        end
      end
    end
  end
end
