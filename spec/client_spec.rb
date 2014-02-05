require 'spec_helper'

describe Callcredit::Client do
  let(:client) { Callcredit::Client.new }

  describe "#connection" do
    subject { client.connection }

    its(:headers) { should include "Accept" => "application/xml" }
    its(:headers) { should include "User-Agent" => Callcredit.user_agent }

    specify { subject.build_url("./").to_s == client.api_endpoint }
  end

  describe "#credit_check" do
    before do
      stub_request(:get, client.api_endpoint)
    end

    it "makes a get request" do
      client.credit_check(first_name: "Grey", last_name: "Baker")
      a_request(:get, client.api_endpoint).should have_been_made
    end
  end
end
