require "callcredit/util"
require "nokogiri"

module Callcredit
  module Request
    # Perform a credit check
    def check(checks, options={}, raw=false)
      response = connection(raw).send(:get) do |request|
        request.path = api_endpoint
        request.body = build_request_xml(checks, options).to_s
      end
      return response if raw
      check_response(response)
      response.body
    rescue Faraday::Error::ClientError => e
      raise APIError.new(e.response[:body], e.response[:status], e.response)
    end

    # Compile the complete XML request to send to Callcredit
    def build_request_xml(checks, options={})
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.callvalidate do
          authentication(xml)
          xml.sessions do
            xml.session do
              xml.data do
                required_checks(xml, checks)
                personal_data(xml, options[:personal_data])
                card_data(xml, options[:card_data])
                bank_data(xml, options[:bank_data])
                income_data(xml, options[:income_data])
              end
            end
          end
          xml.application self.application_name
        end
      end
      builder.doc
    end

    private

    # TODO: move me to middleware?
    def check_response(response)
      unless results = response.body["Results"] rescue nil
        raise APIError.new("Received unexpected XML (Results tag missing")
      end

      if results["Errors"]
        errors = results["Errors"].map { |_,v| v["__content__"] }
        raise APIError.new(errors.join(", "), response.status, response)
      end
    end

    # Authentication details
    def authentication(xml)
      xml.authentication do
        xml.company self.company
        xml.username self.username
        xml.password self.password
      end
    end

    # Set the checks to be performed
    def required_checks(xml, checks)
      required_checks = [*checks].map { |c| Util.underscore(c).to_sym }
      xml.ChecksRequired do
        Callcredit::Constants::CHECKS.each do |check|
          included = required_checks.include?(Util.underscore(check).to_sym)
          xml.send(check, included ? "yes" : "no")
        end
      end
    end

    def personal_data(xml, data)
      unless data.is_a? Hash
        raise InvalidRequestError.new(
          "All checks require personal_data",
          :personal_data)
      end

      xml.Personal do
        xml.Individual do
          xml.Dateofbirth           data[:date_of_birth]
          xml.Title                 "Mr" # Title is mandatory but ignored...
          xml.Firstname             data[:first_name]
          xml.Othernames            data[:middle_names]
          xml.Surname               data[:last_name]
          xml.Phonenumber           data[:phone]
          xml.Drivinglicensenumber  data[:driving_license]
        end
        xml.Address do
          xml.Buildingnumber        data[:building_number]
          xml.Buildingname          data[:building_name]
          xml.Address1              data[:address_line_1]
          xml.Postcode              data[:postcode]
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