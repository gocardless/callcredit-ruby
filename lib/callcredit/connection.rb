require 'faraday_middleware'

module Callcredit
  module Connection
    def connection(raw=false)
      raise AuthenticationError unless authenticated?

      options = {
        ssl: { verify: false },
        url: api_endpoint,
        headers: {
          'Accept' => "application/xml",
          'User-Agent' => user_agent
        }
      }

      Faraday.new(options) do |conn|
        conn.response :xml unless raw                         # Parse response
        conn.response :follow_redirects, limit: 3             # Follow redirect
        conn.response :raise_error                            # Raise errors
        conn.adapter adapter
      end
    end

    private

    def auth_params
      {
        company:              company,
        username:             username,
        password:             password,
        application_name:     application_name,
      }
    end

    def authenticated?
      auth_params.values.all?
    end
  end
end