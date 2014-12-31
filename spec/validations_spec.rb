require 'spec_helper'

describe Callcredit::Validations do
  describe '#clean_date_of_birth' do
    subject { Callcredit::Validations.clean_date_of_birth(date_of_birth) }

    context "without a date of birth" do
      let(:date_of_birth) { nil }
      it { is_expected.to eq(nil) }
    end

    context "with a date object" do
      let(:date_of_birth) { Date.parse("01/01/2000") }
      it { is_expected.to eq(date_of_birth.strftime("%d/%m/%Y")) }
    end

    context "with a parseable string" do
      let(:date_of_birth) { "01-01-2000" }
      it { is_expected.to eq("01/01/2000") }
    end

    context "with a load of rubbish" do
      let(:date_of_birth) { "A couple of weeks ago" }
      it "raises an error" do
        expect { subject }.to raise_error Callcredit::InvalidRequestError
      end
    end
  end

  describe '#clean_name' do
    subject { Callcredit::Validations.clean_name(name, :first_name) }

    context "without a name" do
      let(:name) { nil }
      it { is_expected.to eq(nil) }
    end

    context "with a simple name" do
      let(:name) { "Grey" }
      it { is_expected.to eq(name) }
    end

    context "with a name with non-ASCII characters" do
      let(:name) { "Gréy" }
      it { is_expected.to eq("Grey") }
    end

    context "with a very long name" do
      let(:name) { "A" * 31 }
      it "raises an error" do
        expect { subject }.to raise_error Callcredit::InvalidRequestError
      end
    end

    context "with a name with numbers in it" do
      let(:name) { "David the 3rd" }
      it "raises an error" do
        expect { subject }.to raise_error Callcredit::InvalidRequestError
      end
    end
  end

  describe '#clean_postcode' do
    subject { Callcredit::Validations.clean_postcode(postcode, :postcode) }

    context "without a postcode" do
      let(:postcode) { nil }
      it { is_expected.to eq(nil) }
    end

    context "with a correct postcode" do
      let(:postcode) { "EC2A 1DX" }
      it { is_expected.to eq(postcode) }
    end

    context "with a padded postcode" do
      let(:postcode) { "EC2A 1DX    " }
      it { is_expected.to eq("EC2A 1DX") }
    end

    context "with a postcode that is too short" do
      let(:postcode) { "N1" }
      it "raises an error" do
        expect { subject }.to raise_error Callcredit::InvalidRequestError
      end
    end
  end

  describe '#clean_account_number' do
    subject { Callcredit::Validations.clean_account_number(account_number) }

    context "without an account_number" do
      let(:account_number) { nil }
      it { is_expected.to eq(nil) }
    end

    context "with a correct account_number" do
      let(:account_number) { "12345678" }
      it { is_expected.to eq(account_number) }
    end

    context "with a padded account_number" do
      let(:account_number) { " 1234 5678   " }
      it { is_expected.to eq("12345678") }
    end

    context "with an account_number with letters" do
      let(:account_number) { "N1234567" }
      it "raises an error" do
        expect { subject }.to raise_error Callcredit::InvalidRequestError
      end
    end

    context "with an account_number with too many numbers" do
      let(:account_number) { "123456789" }
      it "raises an error" do
        expect { subject }.to raise_error Callcredit::InvalidRequestError
      end
    end
  end

  describe '#clean_sort_code' do
    subject { Callcredit::Validations.clean_sort_code(sort_code) }

    context "without a sort_code" do
      let(:sort_code) { nil }
      it { is_expected.to eq(nil) }
    end

    context "with a correct sort_code" do
      let(:sort_code) { "123456" }
      it { is_expected.to eq(sort_code) }
    end

    context "with a padded sort_code" do
      let(:sort_code) { " 1234 56   " }
      it { is_expected.to eq("123456") }
    end

    context "with a sort_code with letters" do
      let(:sort_code) { "N12345" }
      it "raises an error" do
        expect { subject }.to raise_error Callcredit::InvalidRequestError
      end
    end

    context "with a sort_code with too many numbers" do
      let(:sort_code) { "1234567" }
      it "raises an error" do
        expect { subject }.to raise_error Callcredit::InvalidRequestError
      end
    end
  end
end
