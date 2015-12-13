module TrafficSpy
  class Server < Sinatra::Base
    get '/' do
      haml :homepage, :layout => (request.xhr? ? false : :layout)
    end

    get '/sources' do
      @apps = TrafficSpy::Application.all
      haml :registered_application_index, :layout => (request.xhr? ? false : :layout)
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
      @url = "/" + path
      @url_payloads = @app.payloads.path_matching("/" + path)

      if @url_payloads.empty?
        haml :'error-messages/application_url_statistics_error', locals: {path: path}, :layout => (request.xhr? ? false : :layout)
      else
        haml :'application-url-statistics/application_url_statistics', :layout => (request.xhr? ? false : :layout)
      end
    end

    get '/sources/:id' do |id|
      @app = TrafficSpy::Application.find_by(identifier: id)

      if @app.nil?
        haml :'error-messages/no_application_registered', :layout => (request.xhr? ? false : :layout)
      elsif @app.payloads.to_a.empty?
        haml :'error-messages/no_payloads', :layout => (request.xhr? ? false : :layout)
      else
        haml :'application-detail-statistics/application_details', :layout => (request.xhr? ? false : :layout)
      end
    end

    get '/sources/:id/events' do |id|
      @app = TrafficSpy::Application.find_by(identifier: id)

      if @app.payloads.to_a.empty?
        haml :'error-messages/no_payloads', :layout => (request.xhr? ? false : :layout)
      else
        haml :events_index, :layout => (request.xhr? ? false : :layout)
      end
    end

    get '/sources/:id/events/:event' do |id, event|
      @app = TrafficSpy::Application.find_by(identifier: id)
      @event = event
      @event_payloads = @app.payloads.event_matching(event)

      if @event_payloads.empty?
        haml :'error-messages/event_not_defined', locals: {event: event}, :layout => (request.xhr? ? false : :layout)
      else
        haml :'event-detail-statistics/event_details', :layout => (request.xhr? ? false : :layout)
      end
    end

    not_found do
      haml :'error-messages/error', :layout => (request.xhr? ? false : :layout)
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
