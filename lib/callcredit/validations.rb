module Callcredit
  module Validations

    VALIDATIONS = {
      date_of_birth:      ->(value) { clean_date_of_birth(value) },
      title:              ->(value) { value || "Unknown" },
      first_name:         ->(value) { clean_name(value, :first_name) },
      last_name:          ->(value) { clean_name(value, :last_name) },
      middle_names:       ->(value) { clean_name(value, :middle_names) },
      postcode:           ->(value) { clean_postcode(value, :postcode) },
      previous_postcode:  ->(value) { clean_postcode(value, :previous_postcode) },
      delivery_postcode:  ->(value) { clean_postcode(value, :delivery_postcode) },
      account_number:     ->(value) { clean_account_number(value) },
      sort_code:          ->(value) { clean_sort_code(value) },
    }

    def self.clean_param(key, value)
      validator = VALIDATIONS.fetch(key, ->(value){ value })
      validator.call(value)
    end

    def self.clean_date_of_birth(date_of_birth)
      return unless date_of_birth
      date_of_birth = Date.parse(date_of_birth) if date_of_birth.is_a? String
      date_of_birth.strftime("%d/%m/%Y")
    rescue
      input_error(:date_of_birth, date_of_birth)
    end

    def self.clean_name(name, param)
      return unless name
      # Convert name to ASCII characters only
      name = UnicodeUtils.nfkd(name).gsub(/(\p{Letter})\p{Mark}+/,'\\1')
      input_error(param, name) unless name =~ /\A[a-z A-Z'-]{1,30}\z/
      name
    end

    def self.clean_postcode(postcode, param)
      return unless postcode
      postcode = postcode.upcase.strip
      input_error(param, postcode) unless postcode =~ /\A[A-Z 0-9]{5,8}\z/
      postcode
    end

    def self.clean_account_number(account_number)
      return unless account_number
      cleaned_value = account_number.to_s.gsub(/[-\s]/, '')
      unless cleaned_value =~ /\A\d{6,8}\z/
        input_error(:account_number, account_number)
      end
      cleaned_value
    end

    def self.clean_sort_code(sort_code)
      return unless sort_code
      cleaned_value = sort_code.to_s.gsub(/[-\s]/, '')
      input_error(:sort_code, sort_code) unless cleaned_value =~ /\A\d{6}\z/
      cleaned_value
    end

    def self.input_error(param, value=nil)
      msg = if value.nil?
        "#{param} is a required param"
      else
        %{Invalid value "#{value}" for #{param}}
      end
      raise InvalidRequestError.new(msg, param)
    end
  end
end
