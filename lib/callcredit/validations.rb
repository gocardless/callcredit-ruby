require 'unidecoder'

module Callcredit
  module Validations

    VALIDATIONS = {
      date_of_birth:    ->(value) { clean_date_of_birth(value) },
      title:            ->(value) { value || "Unknown" },
      first_name:       ->(value) { clean_first_name(value) },
      last_name:        ->(value) { clean_last_name(value) },
      middle_names:     ->(value) { clean_middle_names(value) }
    }

    def self.clean_param(key, value)
      validator = VALIDATIONS.fetch(key, ->(value){ value })
      validator.call(value)
    end

    def self.clean_date_of_birth(date_of_birth)
      date_of_birth = Date.parse(date_of_birth) if date_of_birth.is_a? String
      date_of_birth.strftime("%d/%m/%Y")
    rescue
      input_error(:date_of_birth, date_of_birth)
    end

    def self.clean_first_name(name)
      name = name && name.to_ascii
      input_error(:first_name, name) unless name =~ /\A[a-z A-Z'-]{1,30}\z/
      name
    end

    def self.clean_last_name(name)
      name = name && name.to_ascii
      input_error(:last_name, name) unless name =~ /\A[a-z A-Z'-]{1,30}\z/
      name
    end

    def self.clean_middle_names(name)
      return unless name
      name = name.to_ascii
      input_error(:middle_names, name) unless name =~ /\A[a-z A-Z'-]{1,30}\z/
      name
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