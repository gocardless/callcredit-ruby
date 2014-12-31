require 'spec_helper'

describe Callcredit do
  before { Callcredit.instance_variable_set(:@config, nil) }

  describe '#configure' do
    subject { Callcredit.config }
    Callcredit::Config::DEFAULT_OPTIONS.keys.map(&:to_sym).each do |key|
      context "setting #{key}" do
        before { Callcredit.configure { |config| config[key] = key } }

        describe [key] do
          subject { Callcredit.config[key] }
          it { should == key }
        end
      end
    end
  end

  describe "#config" do
    subject(:config) { Callcredit.config }

    it "raises a CallcreditError if Callcredit hasn't been configured" do
      expect { config }.to raise_error Callcredit::CallcreditError
    end
  end

  describe '#id_enhanced_check' do
    before { configure_callcredit }
    let(:data) { { first_name: "Grey", last_name: "Baker" } }

    it "delegates to the client" do
      expect_any_instance_of(Callcredit::Client).
        to receive(:id_enhanced_check).with(data)
      Callcredit.id_enhanced_check(data)
    end
  end

  describe '#bank_standard_check' do
    before { configure_callcredit }
    let(:data) { { account_number: "44779911", sort_code: "200000" } }

    it "delegates to the client" do
      expect_any_instance_of(Callcredit::Client).
        to receive(:bank_standard_check).with(data)
      Callcredit.bank_standard_check(data)
    end
  end

  describe '#bank_enhanced_check' do
    before { configure_callcredit }
    let(:data) { { first_name: "Grey", last_name: "Baker" } }

    it "delegates to the client" do
      expect_any_instance_of(Callcredit::Client).
        to receive(:bank_enhanced_check).with(data)
      Callcredit.bank_enhanced_check(data)
    end
  end

  describe '#perform_check' do
    before { configure_callcredit }
    let(:data) do
      { personal_data: { first_name: "Grey", last_name: "Baker" } }
    end

    it "delegates to the client" do
      expect_any_instance_of(Callcredit::Client).
        to receive(:perform_check).with(:id_enhanced_check, data)
      Callcredit.perform_check(:id_enhanced_check, data)
    end
  end
end
