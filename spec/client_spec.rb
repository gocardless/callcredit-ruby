require 'spec_helper'

describe Callcredit::Client do
  let(:client) { Callcredit::Client.new }
  let(:response_hash) { { status: status, body: body } }
  let(:status) { 200 }
  let(:body) { "<Results><Errors/></Results>" }
  before { client.stub(authenticated?: true) }
  before { stub_request(:get, client.api_endpoint).to_return(response_hash) }

  describe "#connection" do
    subject(:connection) { client.connection }

    context "when not authenticated" do
      before { client.stub(authenticated?: false) }

      it "raises an error" do
        expect { connection }.to raise_error Callcredit::AuthenticationError
      end
    end

    its(:headers) { should include "Accept" => "application/xml" }
    its(:headers) { should include "User-Agent" => Callcredit.user_agent }

    specify { subject.build_url("./").to_s == client.api_endpoint }
  end

  describe "#check" do
    subject(:check) { client.check(:id_enhanced, request_data) }
    let(:request_data) { { personal_data: { date_of_birth: "01/01/2000" } } }

    it "makes a get request" do
      check
      a_request(:get, client.api_endpoint).should have_been_made
    end

    context "errors" do
      context "500" do
        let(:status) { 500 }

        it "wraps the error" do
          expect { check }.to raise_error Callcredit::APIError
        end
      end

      context "400" do
        let(:status) { 400 }

        it "wraps the error" do
          expect { check }.to raise_error Callcredit::APIError
        end
      end

      context "200" do
        context "with errors for Callcredit" do
          let(:body) do
            path = File.join(File.dirname(__FILE__), 'fixtures', 'bad_xml.xml')
            File.open(path.to_s).read
          end

          it "wraps the error" do
            expect { check }.to raise_error Callcredit::APIError
          end
        end

        context "with unexpected XML" do
          let(:body) { "<TopLevel></TopLevel>" }

          it "wraps the error" do
            expect { check }.to raise_error Callcredit::APIError
          end
        end
      end
    end
  end
end
