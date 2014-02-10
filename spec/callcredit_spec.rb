require 'spec_helper'

describe Callcredit do
  describe '#configure' do
    subject { Callcredit.send(:config) }
    Callcredit::Config::DEFAULT_OPTIONS.keys.map(&:to_sym).each do |key|
      context "setting #{key}" do
        before { Callcredit.configure { |config| config[key] = key } }
        its([key]) { should == key }
      end
    end
  end

  describe '#id_enhanced_check' do
    let(:data) { { first_name: "Grey", last_name: "Baker" } }

    it "delegates to the client" do
      Callcredit::Client.any_instance.
        should_receive(:id_enhanced_check).with(data)
      Callcredit.id_enhanced_check(data)
    end
  end
end
