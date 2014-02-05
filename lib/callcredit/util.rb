module Callcredit
  module Util
    extend self

    # Format a Time object according to ISO 8601, and convert to UTC.
    #
    # @param [Time] time the time object to format
    # @return [String] the ISO-formatted time
    def iso_format_time(time)
      return time unless time.is_a? Time or time.is_a? Date
      time = time.getutc if time.is_a? Time
      time = time.new_offset(0) if time.is_a? DateTime
      time.strftime('%Y-%m-%dT%H:%M:%SZ')
    end

    # Recursively ISO format all time and date values.
    #
    # @param [Hash] obj the object containing date or time objects
    # @return [Hash] the object with ISO-formatted time stings
    def stringify_times(obj)
      case obj
      when Hash
        Hash[obj.map { |k,v| [k, stringify_times(v)] }]
      when Array
        obj.map { |v| stringify_times(v) }
      else
        iso_format_time(obj)
      end
    end

    # String helper
    def camelize(str)
      str.split('_').map(&:capitalize).join
    end
  end
end