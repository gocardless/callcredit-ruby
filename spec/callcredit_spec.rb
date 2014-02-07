require 'spec_helper'

describe Callcredit do
  describe "#configure" do
    subject { Callcredit.config }
    Callcredit::Config::DEFAULT_OPTIONS.keys.map(&:to_sym).each do |key|
      context "setting #{key}" do
        before { Callcredit.configure { |config| config[key] = key } }
        its([key]) { should == key }
      end
    end
  end
end
