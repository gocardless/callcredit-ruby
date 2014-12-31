module Callcredit
  class Response
    def initialize(response_data)
      @response_data = response_data
    end

    def rid
      @response_data["Results"]["Result"]["RID"]
    end

    def pid
      @response_data["Results"]["Result"]["PID"]
    end

    def input
      @response_data["Results"]["Result"]["Displays"]["InputData"]
    end

    def result
      @response_data["Results"]["Result"]["Displays"].
        reject { |k, v| displays_excluded_from_results.include?(k) }
    end

    def warnings
      @response_data["Results"]["Result"]["Displays"]["Warnings"]
    end

    def full_result
      @response_data
    end

    private

    def displays_excluded_from_results
      %w(ChecksCompleted InputData Warnings InternalUse)
    end
  end
end
