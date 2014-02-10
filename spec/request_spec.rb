require 'spec_helper'

describe Callcredit::Request do
  let(:request) { Callcredit::Request.new(connection, config) }
  let(:config) { Callcredit::Config.new }
  let(:connection) { Callcredit::Client.new(config).send(:connection) }

  let(:response_hash) { { status: status, body: body } }
  let(:status) { 200 }
  let(:body) { "<Results><Errors/></Results>" }
  before { stub_request(:get, config[:api_endpoint]).to_return(response_hash) }

  let(:check_data) { { personal_data: { date_of_birth: date_of_birth } } }
  let(:date_of_birth) { "01/01/2000" }

  describe '#build_request_xml' do
    subject(:build_request_xml) do
      request.build_request_xml(:id_enhanced, check_data).to_s
    end
    let(:request_xml) do
      path = File.join(File.dirname(__FILE__), 'fixtures', 'request.xml')
      File.open(path.to_s).read
    end

    it { should == request_xml }

    context "with a date object for date_of_birth" do
      let(:date_of_birth) { Date.parse("01/01/2000") }
      it { should == request_xml }
    end
  end

  describe "#perform" do
    subject(:perform_check) { request.perform(:id_enhanced, check_data) }

    it "makes a get request" do
      perform_check
      a_request(:get, config[:api_endpoint]).should have_been_made
    end

    context "when the config[:raw] is true" do
      before { config[:raw] = true }
      it { should be_a Faraday::Response }
      its(:body) { should be_a String }
    end

    context "when the config[:raw] is false" do
      it { should be_a Hash }
      it { should include "Results" }

      context "errors" do
        context "500" do
          let(:status) { 500 }

          it "wraps the error" do
            expect { perform_check }.to raise_error Callcredit::APIError
          end
        end

        context "400" do
          let(:status) { 400 }

          it "wraps the error" do
            expect { perform_check }.to raise_error Callcredit::APIError
          end
        end

        context "200 with a single error from Callcredit" do
          let(:body) do
            path = File.join(File.dirname(__FILE__),
                             'fixtures', 'bad_request.xml')
            File.open(path.to_s).read
          end

          it "wraps the error" do
            expect { perform_check }.
              to raise_error(Callcredit::APIError, "Single error")
          end
        end

        context "200 with multiple errors from Callcredit" do
          let(:body) do
            path = File.join(File.dirname(__FILE__),
                             'fixtures', 'access_denied.xml')
            File.open(path.to_s).read
          end

          it "wraps the error" do
            expect { perform_check }.
              to raise_error(Callcredit::APIError, "Error1 | Error2")
          end
        end

        context "200 with unexpected XML" do
          let(:body) { "<TopLevel></TopLevel>" }

          it "wraps the error" do
            expect { perform_check }.to raise_error Callcredit::APIError
          end
        end
      end
    end
  end
end
