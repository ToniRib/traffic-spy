module TrafficSpy
  class Server < Sinatra::Base
    get '/' do
      haml :homepage
    end

    get '/sources' do
      @apps = TrafficSpy::Application.all
      haml :index
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
      @url = "/" + path
      @id = id
      @app = TrafficSpy::Application.find_by(identifier: id)
      @urls = @app.payloads.matching(@url)

      if @urls.empty?
        haml :application_url_statistics_error
      else
        haml :'application-url-statistics/application_url_statistics'
      end
    end

    get '/sources/:id' do |id|
      @app = TrafficSpy::Application.find_by(identifier: id)

      if @app.nil?
        haml :no_app_registered
      elsif @app.payloads.to_a.empty?
        haml :no_payloads
      else
        haml :application_details
      end
    end

    get '/sources/:id/events' do |id|
      @app = TrafficSpy::Application.find_by(identifier: id)

      if @app.payloads.to_a.empty?
        haml :no_payloads
      else
        haml :events_index
      end
    end

    get '/sources/:id/events/:event' do |id, event|
      @app = TrafficSpy::Application.find_by(identifier: id)
      @event_payloads = app.payloads.where(event: event)
      @event = event

      if @event_payloads.empty?
        haml :event_not_defined
      else
        haml :event_details
      end
    end

    not_found do
      haml :error
    end
  end
end
