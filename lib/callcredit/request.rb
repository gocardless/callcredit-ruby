require "nokogiri"

module Callcredit
  module Request
    # Perform a credit check
    def credit_check(options, raw=false)
      response = connection(raw).send(:get) do |request|
        request.path = api_endpoint
        request.body = build_request_xml(options).to_s
      end
      raw ? response : response.body
    rescue Faraday::Error::ClientError => e
      raise Callcredit::ApiError.new(e.response)
    end

    private

    def build_request_xml(options={})
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.callvalidate do
          authentication(xml)
          xml.sessions do
            session(xml, options)
          end
          xml.application self.application_name
        end
      end

      builder.doc
    end

    def authentication(xml)
      xml.authentication do
        xml.company self.company
        xml.username self.username
        xml.password self.password
      end
    end

    def session(xml, options)
      xml.session do
        xml.data do
          xml.ChecksRequired do
            xml.BankStandard "no"
            xml.BankEnhanced "no"
            xml.CardLive "no"
            xml.CardEnhanced "no"
            xml.IDEnhanced "yes"
            xml.NCOAAlert "no"
            xml.CallValidate3D "no"
            xml.TheAffordabilityReport "no"
            xml.DeliveryFraud "no"
            xml.EmailValidate "no"
            xml.CreditScore "no"
            xml.Zodiac "no"
            xml.IPAddress "no"
            xml.BankAccountPlus "no"
            xml.BankOFA "no"
            xml.CardOFA "no"
          end
          xml.Personalinformation do
            xml.IndividualDetails do
              xml.Dateofbirth options[:date_of_birth]
              xml.Title "Mr"
              xml.Firstname options[:first_name]
              xml.Surname options[:last_name]
            end
            xml.AddressDetails do
              xml.Buildingnumber options[:building_number]
              xml.Buildingname options[:building_name]
              xml.Postcode options[:postcode]
            end
          end
        end
      end
    end
  end
end