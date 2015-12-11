require 'useragent'

module TrafficSpy
  class ProcessRequestParser
    def parse_request(string)
      parsed_request = JSON.parse(string)

      user_agent_string = parsed_request["userAgent"]
      user_agent = UserAgent.parse(user_agent_string)

      url = parsed_request["url"]
      uri = URI(url)

      {
        :relative_path_string => uri.path,
        :requested_at => parsed_request["requestedAt"],
        :responded_in => parsed_request["respondedIn"],
        :referred_by => parsed_request["referredBy"],
        :request_type_string => parsed_request["requestType"],
        :event => parsed_request["eventName"],
        :operating_system_string => user_agent.platform,
        :browser_string => user_agent.browser,
        :resolution_string => {:width => parsed_request["resolutionWidth"],
                               :height => parsed_request["resolutionHeight"]},
        :ip_address => parsed_request["ip"]
      }
    end
  end
end
