require 'spec_helper'

describe Callcredit::Client do
  let(:client) { Callcredit::Client.new }

  describe "#connection" do
    subject { client.connection }

    its(:headers) { should include "Accept" => "application/xml" }
    its(:headers) { should include "User-Agent" => Callcredit.user_agent }

    specify { subject.build_url("./").to_s == client.api_endpoint }
  end

  describe "#check" do
    subject(:check) { client.check(:id_enhanced, data) }
    before { stub_request(:get, client.api_endpoint) }
    let(:data) { { personal_data: { date_of_birth: "01/01/2000" } } }

    it "makes a get request" do
      client.check(:id_enhanced, data)
      a_request(:get, client.api_endpoint).should have_been_made
    end

    context "errors" do
      before { stub_request(:get, client.api_endpoint).to_return(error_hash) }

      context "500" do
        let(:error_hash) { { status: 500 } }

        it "wraps the error" do
          expect { check }.to raise_error Callcredit::ApiError
        end
      end

      context "400" do
        let(:error_hash) { { status: 400 } }

        it "wraps the error" do
          expect { check }.to raise_error Callcredit::ApiError
        end
      end
    end
  end

  describe "#id_enhanced_check" do
    before { stub_request(:get, client.api_endpoint) }
    let(:data) do
      { first_name: "Grey",
        last_name: "Baker",
        date_of_birth: "01/01/2000",
        postcode: "EC2A 1DX",
        building_number: "22-25" }
    end

    it "makes a get request" do
      client.id_enhanced_check(data)
      a_request(:get, client.api_endpoint).should have_been_made
    end
  end
end
