require 'spec_helper'
require 'multi_xml'

describe Callcredit::Response do
  let(:result_hash) { MultiXml.parse(load_fixture('response.xml')) }
  subject(:response) { Callcredit::Response.new(result_hash) }

  it "makes some helper methods available" do
    response.pid.should == "LTJ-CT2-1606-13927-46399"
  end
end
