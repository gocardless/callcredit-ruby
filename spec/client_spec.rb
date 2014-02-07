require 'spec_helper'

describe Callcredit::Client do
  let(:client) { Callcredit::Client.new(config) }
  let(:config) { Callcredit::Config.new }
  let(:check_data) { {} }

  describe "#id_enhanced_check" do
    it "delegates to an instance of IDEnhanced" do
      expect_any_instance_of(Callcredit::Checks::IDEnhanced).
        to receive(:perform).once
      client.id_enhanced_check(check_data)
    end
  end

  describe "#perform_check" do
    subject(:perform_check) { client.id_enhanced_check(check_data) }

    it "delegates to an instance of Request" do
      expect_any_instance_of(Callcredit::Request).to receive(:perform).once
      client.perform_check(:check_type, check_data)
    end
  end
end
