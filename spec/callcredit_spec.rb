require 'spec_helper'

describe Callcredit do
  before { Callcredit.instance_variable_set(:@config, nil) }

  describe '#configure' do
    subject { Callcredit.config }
    Callcredit::Config::DEFAULT_OPTIONS.keys.map(&:to_sym).each do |key|
      context "setting #{key}" do
        before { Callcredit.configure { |config| config[key] = key } }
        its([key]) { should == key }
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
      Callcredit::Client.any_instance.
        should_receive(:id_enhanced_check).with(data)
      Callcredit.id_enhanced_check(data)
    end
  end
end
