require 'spec_helper'

describe Callcredit::Checks::BankStandard do
  let(:bank_standard_check) { Callcredit::Checks::BankStandard.new(client) }
  let(:client) { Callcredit::Client.new(config) }
  let(:config) { Callcredit::Config.new }

  let(:response_hash) { { status: status, body: body } }
  let(:status) { 200 }
  let(:body) { response_xml }
  let(:response_xml) { load_fixture('response.xml') }
  before { stub_request(:get, config[:api_endpoint]).to_return(response_hash) }

  describe "#perform" do
    subject(:perform_check) { bank_standard_check.perform(check_data) }

    let(:check_data) do
      { account_number: "44779911",
        sort_code: "200000" }
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
      it_behaves_like "it validates presence", :account_number
      it_behaves_like "it validates presence", :sort_code
    end
  end
end
