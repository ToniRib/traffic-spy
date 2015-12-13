module TrafficSpy
  class AppStatsJson
    def initialize(id)
      @id = id
      @app = TrafficSpy::Application.find_by(identifier: id)
    end

    def generate_statistics
       {identifier: @id,
        most_requested_urls: most_requested_urls,
        web_browser: web_browser,
        operating_system: operating_system,
        screen_resolution: screen_resolution,
        average_response_times: average_response_times
        }
    end

    def most_requested_urls
      @app.relative_path_requests
    end

    def web_browser
      @app.browser_requests
    end

    def operating_system
      @app.operating_system_requests
    end

    def screen_resolution
      @app.resolution_requests
    end

    def average_response_times
      @app.average_response_times.to_h
    end
  end
end
