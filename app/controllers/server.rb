module TrafficSpy
  class Server < Sinatra::Base
    get '/' do
      haml :homepage
    end

    get '/sources.json' do
      json :registered_applications => TrafficSpy::Application.all.pluck(:identifier)
    end

    get '/sources' do
      @apps = TrafficSpy::Application.all
      haml :registered_application_index
    end

    post '/sources' do
      response_status, response_body =  TrafficSpy::RegisterApplication.new(params).save

      status response_status
      body response_body
    end

    post '/sources/:id/data' do |id|
      response_status, response_body = TrafficSpy::ProcessPayload.new(params[:payload], id).process

      status response_status
      body response_body
    end

    get '/sources/:id/urls/:path.json' do |id, path|
      @app = TrafficSpy::Application.find_by(identifier: id)
      @path = @app.relative_paths.find_by(path: "/" + path)
      url_stats_calculator = TrafficSpy::URLStatsJson.new(id, path)

      if @path.nil?
        json identifier: id, path: "/" + path, message: "URL has not been requested"
      else
        json url_stats_calculator.generate_statistics
      end
    end

    get '/sources/:id/urls/:path' do |id, path|
      @app = TrafficSpy::Application.find_by(identifier: id)
      @path = @app.relative_paths.find_by(path: "/" + path)

      if @path.nil?
        haml :'error-messages/application_url_statistics_error', locals: {path: path}
      else
        haml :'application-url-statistics/application_url_statistics'
      end
    end

    get '/sources/:id.json' do |id|
      @app = TrafficSpy::Application.find_by(identifier: id)
      app_stats_calculator = TrafficSpy::AppStatsJson.new(id)

      if @app.nil?
        json identifier: id, message: "Identifier has not been registered"
      elsif @app.payloads.to_a.empty?
        json identifier: id, message: "No Payload data has been received for this source"
      else
        json app_stats_calculator.generate_statistics
      end
    end

    get '/sources/:id' do |id|
      @app = TrafficSpy::Application.find_by(identifier: id)

      if @app.nil?
        haml :'error-messages/no_application_registered'
      elsif @app.payloads.to_a.empty?
        haml :'error-messages/no_payloads'
      else
        haml :'application-detail-statistics/application_details'
      end
    end

    get '/sources/:id/events.json' do |id|
      @app = TrafficSpy::Application.find_by(identifier: id)

      if @app.payloads.to_a.empty?
        json identifier: id, message: "No Payload data has been received for this source"
      else
        json identifier: id, events_index: @app.events.pluck(:event_name)
      end
    end

    get '/sources/:id/events' do |id|
      @app = TrafficSpy::Application.find_by(identifier: id)

      if @app.payloads.to_a.empty?
        haml :'error-messages/no_payloads'
      else
        haml :events_index
      end
    end

    get '/sources/:id/events/:event.json' do |id, event|
      @app = TrafficSpy::Application.find_by(identifier: id)
      @event = @app.events.find_by(event_name: event)
      app_stats_calculator = TrafficSpy::EventStatsJson.new(id, event)

      if @event.nil?
        json identifier: id, event: event, message: "#{event} has not been defined for this application"
      else
        json app_stats_calculator.generate_statistics
      end
    end

    get '/sources/:id/events/:event' do |id, event|
      @app = TrafficSpy::Application.find_by(identifier: id)
      @event = @app.events.find_by(event_name: event)

      if @event.nil?
        haml :'error-messages/event_not_defined', locals: {event: event}
      else
        haml :'event-detail-statistics/event_details'
      end
    end

    not_found do
      haml :'error-messages/error'
    end

    helpers do
      def link_to_url(app_name, path)
        "<a href='/sources/#{app_name}/urls#{path}' class='cyan-text text-lighten-3 card-link'> #{path}"
      end

      def link_to_application(app_name)
        "<a href='/sources/#{app_name}'><h3 class='title-text btn-large cyan darken-2 waves-effect waves-light shadow center non-dashboard-text'>#{app_name}</h3></a>"
      end

      def link_to_event(app_name, event, count)
        "<a href='/sources/#{app_name}/events/#{event}'><h3 class='title-text btn-large cyan darken-2 non-dashboard-text waves-effect waves-light shadow center'>#{event} - #{count}</h3></a>"
      end

      def list_item_with_count(item, count)
        "<li>#{item} (#{count})</li>"
      end
    end
  end
end
