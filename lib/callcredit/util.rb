module Callcredit
  module Util
    extend self
    # String helper
    def camelize(str)
      str.split('_').map(&:capitalize).join
    end

    def underscore(str)
      str.to_s.gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').
        gsub(/([a-z\d])([A-Z])/, '\1_\2').
        tr("-", "_").
        downcase
    end
  end
end
