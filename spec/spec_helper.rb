require 'callcredit'
require 'webmock/rspec'
RSpec.configure { |config| config.include WebMock::API }

shared_examples "it validates presence" do |property|
  context "with a missing #{property}" do
    before { data.delete(property) }

    it "raises and error" do
      expect { subject }.to raise_error
    end
  end
end