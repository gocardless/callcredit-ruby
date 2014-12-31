require 'spec_helper'

describe Callcredit::Checks::BankEnhanced do
  let(:bank_enhanced_check) { Callcredit::Checks::BankEnhanced.new(client) }
  let(:client) { Callcredit::Client.new(config) }
  let(:config) { Callcredit::Config.new }

  let(:response_hash) { { status: status, body: body } }
  let(:status) { 200 }
  let(:body) { response_xml }
  let(:response_xml) { load_fixture('response.xml') }
  before { stub_request(:get, config[:api_endpoint]).to_return(response_hash) }

  describe "#perform" do
    subject(:perform_check) { bank_enhanced_check.perform(check_data) }

    let(:check_data) do
      { first_name: "Grey",
        last_name: "Baker",
        postcode: "EC2A 1DX",
        building_number: "22-25",
        sort_code: "200000",
        account_number: "44779911" }
    end

    it "separates the supplied data into personal and bank details" do
      expect(client).to receive(:perform_check) do |check_types, data|
        expect(data[:personal_data][:postcode]).to eq(check_data[:postcode])
        expect(data[:bank_data][:sort_code]).to eq(check_data[:sort_code])
      end

      perform_check
    end

    it "makes a get request" do
      perform_check
      expect(a_request(:get, config[:api_endpoint])).to have_been_made
    end

    it { is_expected.to be_a Callcredit::Response }

    context "when the config[:raw] is true" do
      before { config[:raw] = true }
      it { is_expected.to be_a Faraday::Response }

      describe '#body' do
        subject { super().body }
        it { should be_a String }
      end
    end

    describe "validates inputs" do
      it_behaves_like "it validates presence", :first_name
      it_behaves_like "it validates presence", :last_name
      it_behaves_like "it validates presence", :postcode
      it_behaves_like "it validates presence", :building_number
      it_behaves_like "it validates presence", :account_number
      it_behaves_like "it validates presence", :sort_code

      context "with a building_name instead of building number" do
        before { check_data.delete(:building_number) }
        before { check_data[:building_name] = "The Mill" }

        it "makes a get request" do
          perform_check
          expect(a_request(:get, config[:api_endpoint])).to have_been_made
        end
      end
    end
  end
end
