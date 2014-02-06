require 'spec_helper'

describe Callcredit::Checks::IDEnhanced do
  class DescribedModule
    include Callcredit::Checks::IDEnhanced
  end

  let(:client) { Callcredit::Client.new }
  let(:described_module) { DescribedModule.new }
  let(:response_hash) { { status: status, body: body } }
  let(:status) { 200 }
  let(:body) { "<Results><Errors/></Results>" }

  describe "#id_enhanced_check" do
    before { stub_request(:get, client.api_endpoint).to_return(response_hash) }
    subject(:id_enhanced_check) { described_module.id_enhanced_check(data) }

    let(:data) do
      { first_name: "Grey",
        last_name: "Baker",
        date_of_birth: "01/01/2000",
        postcode: "EC2A 1DX",
        building_number: "22-25" }
    end

    it "makes a get request" do
      described_module.id_enhanced_check(data)
      a_request(:get, client.api_endpoint).should have_been_made
    end

    it_behaves_like "it validates presence", :first_name
    it_behaves_like "it validates presence", :last_name
    it_behaves_like "it validates presence", :postcode
    it_behaves_like "it validates presence", :date_of_birth
    it_behaves_like "it validates presence", :building_number

    context "with a building_name instead of building number" do
      before { data.delete(:building_number) }
      before { data[:building_name] = "The Mill" }

      it "makes a get request" do
        described_module.id_enhanced_check(data)
        a_request(:get, client.api_endpoint).should have_been_made
      end
    end
  end
end
