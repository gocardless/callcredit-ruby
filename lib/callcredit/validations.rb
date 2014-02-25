require 'unidecoder'

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
      delivery_postcode:  ->(value) { clean_postcode(value, :delivery_postcode) }
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
      name = name.to_ascii
      input_error(param, name) unless name =~ /\A[a-z A-Z'-]{1,30}\z/
      name
    end

    def self.clean_postcode(postcode, param)
      return unless postcode
      postcode = postcode.upcase.strip
      input_error(param, postcode) unless postcode =~ /\A[A-Z 0-9]{5,8}\z/
      postcode
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