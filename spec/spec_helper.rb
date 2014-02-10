require 'callcredit'
require 'webmock/rspec'
RSpec.configure { |config| config.include WebMock::API }

def configure_callcredit
  Callcredit.configure { |config| config[:first_name] = "Grey" }
end

shared_examples "it validates presence" do |property|
  context "with a missing #{property}" do
    before { check_data.delete(property) }

    it "raises and error" do
      expect { subject }.to raise_error Callcredit::InvalidRequestError
    end
  end
end