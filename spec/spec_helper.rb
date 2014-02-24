require 'callcredit'
require 'webmock/rspec'
RSpec.configure { |config| config.include WebMock::API }

def configure_callcredit
  Callcredit.configure do |config|
    config[:company] = "GoCardless"
    config[:username] = "Username"
    config[:password] = "Password"
    config[:application_name] = "Application"
  end
end

def load_fixture(*filename)
  File.open(File.join('spec', 'fixtures', *filename)).read
end

shared_examples "it validates presence" do |property|
  context "with a missing #{property}" do
    before { check_data.delete(property) }

    it "raises and error" do
      expect { subject }.to raise_error Callcredit::InvalidRequestError
    end
  end
end