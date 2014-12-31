module Callcredit
  module Validations
    VALIDATIONS = {
      date_of_birth:     ->(val) { clean_date_of_birth(val) },
      title:             ->(val) { val || "Unknown" },
      first_name:        ->(val) { clean_name(val, :first_name) },
      last_name:         ->(val) { clean_name(val, :last_name) },
      middle_names:      ->(val) { clean_name(val, :middle_names) },
      postcode:          ->(val) { clean_postcode(val, :postcode) },
      previous_postcode: ->(val) { clean_postcode(val, :previous_postcode) },
      account_number:    ->(val) { clean_account_number(val) },
      sort_code:         ->(val) { clean_sort_code(val) },
    }

    def self.clean_param(key, value)
      validator = VALIDATIONS.fetch(key, ->(val) { val })
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
      name = UnicodeUtils.nfkd(name).gsub(/(\p{Letter})\p{Mark}+/, '\\1')
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

    def self.input_error(param, value = nil)
      msg = if value.nil?
              "#{param} is a required param"
            else
              "Invalid value \"#{value}\" for #{param}"
            end

      raise InvalidRequestError.new(msg, param)
    end
  end
end
