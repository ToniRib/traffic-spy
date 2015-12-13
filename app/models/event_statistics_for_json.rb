module TrafficSpy
  class EventStatsJson
    def initialize(id, event)
      @id = id
      @app = TrafficSpy::Application.find_by(identifier: id)
      @event = @app.events.find_by(event_name: event)
    end

    def generate_statistics
       {identifier: @id,
        event: @event,
        total_requests: total_requests,
        hour_by_hour_breakdown: hour_by_hour_breakdown
        }
    end

    def total_requests
      @event.total_requests
    end

    def hour_by_hour_breakdown
      breakdown = (0..23).to_a.map do |hour|
        ["#{hour}:00 - #{hour + 1}:00", @event.requests_by_hour(hour)]
      end
      breakdown.to_h
    end
  end
end
