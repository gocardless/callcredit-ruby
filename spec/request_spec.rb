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
