require 'spec_helper'

describe Callcredit do
  after { Callcredit.reset }

  its(:client) { should be_a Callcredit::Client }

  its(:adapter) { should == Faraday.default_adapter }
  its(:user_agent) { should == "Callcredit Ruby Gem #{Callcredit::VERSION}" }

  describe "#adapter=" do
    before { Callcredit.adapter = :typhoeus }
    its(:adapter) { should == :typhoeus }
  end

  describe "#user_agent=" do
    before { Callcredit.user_agent = 'Custom User Agent' }
    its(:user_agent) { should == 'Custom User Agent' }
  end

  describe "#configure" do
    Callcredit::Configuration::VALID_OPTIONS_KEYS.each do |key|
      before { Callcredit.configure { |config| config.send("#{key}=", key) } }
      its(key.to_sym) { should == key }
    end
  end
end
