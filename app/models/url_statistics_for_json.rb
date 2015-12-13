module TrafficSpy
  class URLStatsJson
    def initialize(id, path)
      @id = id
      @app = TrafficSpy::Application.find_by(identifier: id)
      @path = @app.relative_paths.find_by(path: "/" + path)
      @rel_path = "/" + path
    end

    def generate_statistics
       {identifier: @id,
        path: @rel_path,
        response_times: response_times,
        http_verbs: http_verbs,
        most_popular_referrers: most_popular_referrers,
        most_popular_operating_systems: most_popular_operating_systems,
        most_popular_browsers: most_popular_browsers}
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
