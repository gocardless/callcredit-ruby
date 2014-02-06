module Callcredit
  module Checks
    module IDEnhanced
      REQUIRED_PARAMS = [:date_of_birth, :first_name, :last_name, :postcode]

      def id_enhanced_check(data={}, raw=false)
        check_params(data)

        Callcredit.check(:id_enhanced, { personal_data: data }, raw)
      end

      private

      def check_params(data)
        REQUIRED_PARAMS.each do |param|
          if data[param].nil? || data[param].empty?
            msg = "An IDEnhanced check requires a #{param}"
            raise InvalidRequestError.new(msg, param)
          end
        end

        # For and ID Enhanced check, we also need a building name or number
        unless data[:building_number] || data[:building_name]
          msg = "An IDEnhanced check requires a building number or name"
          raise InvalidRequestError.new(:building_number)
        end
      end
    end
  end
end
