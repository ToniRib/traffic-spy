module TrafficSpy
  class Server < Sinatra::Base
    get '/' do
      haml :homepage
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

    get '/sources/:id/urls/:path' do |id, path|
      @app = TrafficSpy::Application.find_by(identifier: id)
      @path = @app.relative_paths.find_by(path: "/" + path)

      if @path.nil?
        haml :'error-messages/application_url_statistics_error', locals: {path: path}
      else
        haml :'application-url-statistics/application_url_statistics'
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

    get '/sources/:id/events' do |id|
      @app = TrafficSpy::Application.find_by(identifier: id)

      if @app.payloads.to_a.empty?
        haml :'error-messages/no_payloads'
      else
        haml :events_index
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

    use Rack::Auth::Basic, "Enter username & password to view TrafficSpy Dashboard" do |username, password|
      username == 'turing' && password == 'secret'
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
