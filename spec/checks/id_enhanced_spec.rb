require 'spec_helper'

describe Callcredit::Checks::IDEnhanced do
  let(:id_enhanced_check) { Callcredit::Checks::IDEnhanced.new(client) }
  let(:client) { Callcredit::Client.new(config) }
  let(:config) { Callcredit::Config.new }

  let(:response_hash) { { status: status, body: body } }
  let(:status) { 200 }
  let(:body) do
    "<Results>
      <Result>
        <Displays>
          <InputData/>
          <IdentityCheck/>
        </Displays>
      </Result>
      <Errors/>
    </Results>"
  end
  before { stub_request(:get, config[:api_endpoint]).to_return(response_hash) }

  describe "#perform" do
    subject(:perform_check) { id_enhanced_check.perform(check_data) }

    let(:check_data) do
      { first_name: "Grey",
        last_name: "Baker",
        date_of_birth: "01/01/2000",
        postcode: "EC2A 1DX",
        building_number: "22-25" }
    end

    it "makes a get request" do
      perform_check
      a_request(:get, config[:api_endpoint]).should have_been_made
    end

    it { should be_a Callcredit::Response }

    context "when the config[:raw] is true" do
      before { config[:raw] = true }
      it { should be_a Faraday::Response }
      its(:body) { should be_a String }
    end

    describe "validates inputs" do
      it_behaves_like "it validates presence", :first_name
      it_behaves_like "it validates presence", :last_name
      it_behaves_like "it validates presence", :postcode
      it_behaves_like "it validates presence", :date_of_birth
      it_behaves_like "it validates presence", :building_number

      context "with a building_name instead of building number" do
        before { check_data.delete(:building_number) }
        before { check_data[:building_name] = "The Mill" }

        it "makes a get request" do
          perform_check
          a_request(:get, config[:api_endpoint]).should have_been_made
        end
      end
    end
  end
end
