require 'spec_helper'

describe Callcredit::Request do
  before { configure_callcredit }
  let(:request) { Callcredit::Request.new(connection, config) }
  let(:config) { Callcredit.config }
  let(:connection) { Callcredit::Client.new(config).send(:connection) }

  let(:response_hash) { { status: status, body: body } }
  let(:status) { 200 }
  let(:body) { "<Results><Errors/></Results>" }
  before { stub_request(:get, config[:api_endpoint]).to_return(response_hash) }

  let(:check_data) do
    { personal_data: {
        first_name: "Grey",
        last_name: "Baker",
        date_of_birth: date_of_birth,
        postcode: "EC2A 1DX",
        building_number: "22-25"
      }
    }
  end

  let(:date_of_birth) { "01/01/2000" }

  describe '#build_request_xml' do
    subject(:request_xml) do
      request.build_request_xml(:id_enhanced, check_data)
    end
    let(:xml_schema) { load_fixture('request.xsd') }
    let(:xsd) { Nokogiri::XML::Schema(xml_schema) }

    it "generates a valid XML request" do
      expect(xsd.validate(request_xml)).to eq([])
    end

    context "with a date object for date_of_birth" do
      let(:date_of_birth) { Date.parse("01/01/2000") }
      it "generates a valid XML request" do
        expect(xsd.validate(request_xml)).to eq([])
      end
    end

    context "for a BankStandard check" do
      before do
        check_data.merge!(
          bank_data: { account_number: 55779911, sort_code: 200000 }
        )
      end

      subject(:request_xml) do
        request.build_request_xml(:bank_standard, check_data)
      end

      it "generates a valid XML request" do
        expect(xsd.validate(request_xml)).to eq([])
      end
    end

    context "for a BankEnhanced check" do
      before do
        check_data.merge!(
          bank_data: { account_number: 55779911, sort_code: 200000 },
          personal_data: { first_name: "Tim", last_name: "Rogers",
                           postcode: "EC1V 7LQ", building_number: "338-346" }
        )
      end

      subject(:request_xml) do
        request.build_request_xml(:bank_enhanced, check_data)
      end

      it "generates a valid XML request" do
        expect(xsd.validate(request_xml)).to eq([])
      end
    end
  end

  describe "#perform" do
    subject(:perform_check) { request.perform(:id_enhanced, check_data) }

    it "makes a get request" do
      perform_check
      expect(a_request(:get, config[:api_endpoint])).to have_been_made
    end

    context "when the config[:raw] is true" do
      before { config[:raw] = true }
      it { is_expected.to be_a Faraday::Response }

      describe '#body' do
        subject { perform_check.body }
        it { should be_a String }
      end
    end

    context "when the config[:raw] is false" do
      it { is_expected.to be_a Hash }
      it { is_expected.to include "Results" }

      context "errors" do
        context "500" do
          let(:status) { 500 }

          it "wraps the error" do
            expect { perform_check }.to raise_error Callcredit::APIError
          end
        end

        context "400" do
          let(:status) { 400 }

          it "wraps the error" do
            expect { perform_check }.to raise_error Callcredit::APIError
          end
        end

        context "200 with a single error from Callcredit" do
          let(:body) { load_fixture('bad_request.xml') }

          it "wraps the error" do
            expect { perform_check }.
              to raise_error(Callcredit::APIError, "Single error")
          end
        end

        context "200 with multiple errors from Callcredit" do
          let(:body) { load_fixture('access_denied.xml') }

          it "wraps the error" do
            expect { perform_check }.
              to raise_error(Callcredit::APIError, "Error1 | Error2")
          end
        end

        context "200 with errors from Callcredit that aren't in a module" do
          let(:body) { load_fixture('system_call_failure.xml') }

          it "wraps the error" do
            expect { perform_check }.
              to raise_error(Callcredit::APIError, "Error 1 | Error 2")
          end
        end

        context "200 with unexpected XML" do
          let(:body) { "<TopLevel></TopLevel>" }

          it "wraps the error" do
            expect { perform_check }.
              to raise_error Callcredit::InvalidResponseError
          end
        end
      end
    end
  end
end
