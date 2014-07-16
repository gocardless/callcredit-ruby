module Callcredit
  class Request
    def initialize(connection, config)
      @connection = connection
      @config = config
    end

    # Perform a credit check
    def perform(checks, check_data = {})
      # check_data = Callcredit::Validator.clean_check_data(check_data)
      response = @connection.get do |request|
        request.path = @config[:api_endpoint]
        request.body = build_request_xml(checks, check_data).to_s
      end
      @config[:raw] ? response : response.body
    rescue Faraday::Error::ClientError => e
      if e.response.nil?
        raise APIError.new
      else
        raise APIError.new(e.response[:body], e.response[:status], e.response)
      end
    end

    # Compile the complete XML request to send to Callcredit
    def build_request_xml(checks, check_data={})
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.callvalidate do
          authentication(xml)
          xml.sessions do
            xml.session("RID" => Time.now.to_f) do
              xml.data do
                personal_data(xml, check_data[:personal_data])
                card_data(xml, check_data[:card_data])
                bank_data(xml, check_data[:bank_data])
                income_data(xml, check_data[:income_data])
                required_checks(xml, checks)
              end
            end
          end
          xml.application @config[:application_name]
        end
      end
      builder.doc
    end

    private

    # Authentication details
    def authentication(xml)
      xml.authentication do
        xml.company @config[:company]
        xml.username @config[:username]
        xml.password @config[:password]
      end
    end

    # Checks to be performed
    def required_checks(xml, checks)
      required_checks = [*checks].map { |c| Util.underscore(c).to_sym }
      xml.ChecksRequired do
        Constants::CHECKS.each do |check|
          included = required_checks.include?(Util.underscore(check).to_sym)
          xml.send(check, included ? "yes" : "no")
        end
      end
    end

    def personal_data(xml, data)
      unless data.is_a? Hash
        raise InvalidRequestError.new(
          "All checks require personal_data", :personal_data)
      end

      xml.Personalinformation do
        xml.IndividualDetails do
          Constants::INDIVIDUAL_DETAILS.each do |param, element_name|
            value = Validations.clean_param(param, data[param])
            xml.send(element_name, value) if value
          end
        end
        xml.AddressDetails do
          Constants::ADDRESS_DETAILS.each do |param, element_name|
            value = Validations.clean_param(param, data[param])
            xml.send(element_name, value) if value
          end
        end
      end
    end

    def card_data(xml, data)
      # Not implemented
    end

    def bank_data(xml, data)
      # Not implemented
    end

    def income_data(xml, data)
      # Not implemented
    end
  end
end
