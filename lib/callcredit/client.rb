module Callcredit
  class Client
    def initialize(config = nil)
      @config = (config || Callcredit.config).clone
    end

    def id_enhanced_check(check_data)
      check = Checks::IDEnhanced.new(self)
      check.perform(check_data)
    end

    def perform_check(check_types, check_data)
      request = Request.new(connection, @config)
      request.perform(check_types, check_data)
    end

    def config
      @config
    end

    private

    def connection
      options = {
        ssl: { verify: false },
        url: @config[:api_endpoint],
        headers: {
          'Accept' => "application/xml",
          'User-Agent' => @config[:user_agent]
        }
      }

      Faraday.new(options) do |conn|
        conn.response :check_response unless @config[:raw]  # Check XML
        conn.response :xml  unless @config[:raw]            # Parse response
        conn.response :follow_redirects, limit: 3           # Follow redirect
        conn.response :raise_error                          # Raise errors
        conn.adapter @config[:adapter]
      end
    end
  end
end
