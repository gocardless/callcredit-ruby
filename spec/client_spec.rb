require 'spec_helper'

describe Callcredit::Client do
  let(:client) { Callcredit::Client.new(config) }
  let(:config) { Callcredit::Config.new }
  let(:check_data) { {} }

  describe "#new" do
    context "without a config" do
      before { configure_callcredit }
      subject(:new_client) { Callcredit::Client.new }

      its(:config) { should_not == Callcredit.config }
      it "has the attributes of the global config" do
        new_client.config[:first_name] == Callcredit.config[:first_name]
      end
    end

    context "with a config" do
      before { config[:first_name] = "test" }
      subject(:new_client) { Callcredit::Client.new(config) }

      its(:config) { should_not == config }
      it "has the attributes of the passed in config" do
        new_client.config[:first_name] == config[:first_name]
      end
    end
  end

  describe "#id_enhanced_check" do
    it "delegates to an instance of IDEnhanced" do
      expect_any_instance_of(Callcredit::Checks::IDEnhanced).
        to receive(:perform).once
      client.id_enhanced_check(check_data)
    end
  end

  describe "#perform_check" do
    subject(:perform_check) { client.perform_check(:check_type, check_data) }

    it "delegates to an instance of Request" do
      expect_any_instance_of(Callcredit::Request).to receive(:perform).once
      perform_check
    end
  end
end
