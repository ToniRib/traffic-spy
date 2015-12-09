module TrafficSpy
  class Server < Sinatra::Base
    get '/' do
      haml :index
    end

    post '/sources' do
      register_app = TrafficSpy::RegisterApplication.new(params)
      response_status, response_body = register_app.save

      status response_status
      body response_body
    end

    post '/sources/:id/data' do |id|
      if params[:payload].nil?
        status 400
        body "Payload can't be blank"
      elsif TrafficSpy::Application.find_by(identifier: id).nil?
        status 403
        body "Identifier not registered"
      else
        parsed_string = TrafficSpy::ProcessRequestParser.new.parse_request(params[:payload])
        app = TrafficSpy::Application.find_by(identifier: id)
        payload = app.payloads.new(parsed_string)
        if payload.save
          status 200
        else
          status 403
          body "Already received request"
        end
      end
    end

    get '/sources/:id' do |id|
      @app = TrafficSpy::Application.find_by(identifier: id)
      haml :url_statistics
    end

    not_found do
      haml :error
    end
  end
end
