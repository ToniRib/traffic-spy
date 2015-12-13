module TrafficSpy
  class AppStatsJson
    def initialize(id)
      @id = id
      @app = TrafficSpy::Application.find_by(identifier: id)
    end

    def generate_statistics
       {identifier: @id,
        most_requested_urls: most_requested_urls,
        response_times: response_times,
        http_verbs: http_verbs,
        most_popular_referrers: most_popular_referrers,
        most_popular_operating_systems: most_popular_operating_systems,
        most_popular_browsers: most_popular_browsers}
    end

    def most_requested_urls
      @app.relative_path_requests
    end

    def response_times
       {maximum: @path.max_response_time,
        minimum: @path.min_response_time,
        average: @path.avg_response_time}
    end

    def http_verbs
      @path.verbs.to_h
    end

    def most_popular_referrers
      @path.top_3_referrers.to_h
    end

    def most_popular_operating_systems
      @path.top_3_operating_systems.to_h
    end

    def most_popular_browsers
      @path.top_3_browsers.to_h
    end
  end
end
