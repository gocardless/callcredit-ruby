require 'spec_helper'

describe Callcredit::Client do
  let(:client) { Callcredit::Client.new }

  describe "#connection" do
    subject { client.connection }

    its(:headers) { should include "Accept" => "application/xml" }
    its(:headers) { should include "User-Agent" => Callcredit.user_agent }

    specify { subject.build_url("./").to_s == client.api_endpoint }
  end

  describe "#check" do
    before { stub_request(:get, client.api_endpoint) }
    let(:data) do
      { personal_data: { first_name: "Grey", last_name: "Baker" } }
    end

    it "makes a get request" do
      client.check(:id_enhanced, data)
      a_request(:get, client.api_endpoint).should have_been_made
    end
  end
end
