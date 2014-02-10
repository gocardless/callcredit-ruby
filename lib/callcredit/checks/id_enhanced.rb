module Callcredit
  module Checks
    class IDEnhanced
      REQUIRED_INPUTS = [:date_of_birth, :first_name, :last_name, :postcode]

      def initialize(client)
        @client = client
      end

      def perform(data = {})
        check_params(data)
        response = @client.perform_check(:id_enhanced, personal_data: data)
        CheckResponse.new(response) unless @client.config[:raw]
      end

      private

      def check_params(data)
        REQUIRED_INPUTS.each do |param|
          if data[param].nil?
            msg = "An IDEnhanced check requires a #{param}"
            raise InvalidRequestError.new(msg, param)
          end
        end

        # For and ID Enhanced check, we also need a building name or number
        unless data[:building_number] || data[:building_name]
          msg = "An IDEnhanced check requires a building number or name"
          raise InvalidRequestError.new(msg, :building_number)
        end
      end
    end
  end
end
