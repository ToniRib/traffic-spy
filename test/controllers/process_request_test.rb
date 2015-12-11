require './test/test_helper'

class ProcessRequestTest < ControllerTest
  def test_does_not_process_request_without_payload
    TrafficSpy::Application.create({ identifier: "turing", root_url: "http://turing.io"})

    post '/sources/turing/data'

    assert_equal 400, last_response.status
    assert_equal "Payload can't be blank", last_response.body
    assert_equal 0, TrafficSpy::Payload.count
  end

  def test_does_not_process_request_for_unregistered_application
    payload = { payload: '{
                          "url":"http://jumpstartlab.com/blog",
                          "requestedAt":"2013-02-16 21:38:28 -0700",
                          "respondedIn":37,
                          "referredBy":"http://jumpstartlab.com",
                          "requestType":"GET",
                          "parameters":[],
                          "eventName": "socialLogin",
                          "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
                          "resolutionWidth":"1920",
                          "resolutionHeight":"1280",
                          "ip":"63.29.38.211"
                          }'
    }

    post '/sources/turing/data', payload

    assert_equal 403, last_response.status
    assert_equal "Identifier not registered", last_response.body
    assert_equal 0, TrafficSpy::Payload.count
  end

  def test_responds_with_200_for_valid_and_unique_payload
    TrafficSpy::Application.create({ identifier: "turing", root_url: "http://turing.io"})

    payload = { payload: '{
                          "url":"http://turing.io/blog",
                          "requestedAt":"2013-02-16 21:38:28 -0700",
                          "respondedIn":37,
                          "referredBy":"http://turing.io",
                          "requestType":"GET",
                          "parameters":[],
                          "eventName": "socialLogin",
                          "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
                          "resolutionWidth":"1920",
                          "resolutionHeight":"1280",
                          "ip":"63.29.38.211"
                          }'
    }

    post '/sources/turing/data', payload

    assert_equal 200, last_response.status
    assert_equal 1, TrafficSpy::Payload.count
  end

  def test_responds_with_403_for_a_non_unique_payload
    app = TrafficSpy::Application.create({ identifier: "turing", root_url: "http://turing.io"})

    payload = { payload: '{
                          "url":"http://turing.io/blog",
                          "requestedAt":"2013-02-16 21:38:28 -0700",
                          "respondedIn":37,
                          "referredBy":"http://turing.io",
                          "requestType":"GET",
                          "parameters":[],
                          "eventName": "socialLogin",
                          "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
                          "resolutionWidth":"1920",
                          "resolutionHeight":"1280",
                          "ip":"63.29.38.211"
                          }'
    }

    parser = TrafficSpy::ProcessRequestParser.new

    parsed_string = parser.parse_request(payload[:payload])
    rel_path = TrafficSpy::RelativePath.find_or_create_by(path: parsed_string[:relative_path_string])
    req_type = TrafficSpy::RequestType.find_or_create_by(verb: parsed_string[:request_type_string])
    resolution = TrafficSpy::Resolution.find_or_create_by(width: parsed_string[:resolution_string][:width],
                                                          height: parsed_string[:resolution_string][:height])
    operating_system = TrafficSpy::OperatingSystem.find_or_create_by(op_system: parsed_string[:operating_system_string])
    browser = TrafficSpy::Browser.find_or_create_by(browser_name: parsed_string[:browser_string])
    parsed_string[:browser_id] = browser.id
    parsed_string[:operating_system_id] = operating_system.id
    parsed_string[:resolution_id] = resolution.id
    parsed_string[:request_type_id] = req_type.id
    parsed_string[:relative_path_id] = rel_path.id
    parsed_string[:application_id] = app.id

    TrafficSpy::Payload.create(parsed_string)

    post '/sources/turing/data', payload

    assert_equal 403, last_response.status
    assert_equal "Already received request", last_response.body
  end

  def test_allows_two_unique_payloads_with_different_urls
    app = TrafficSpy::Application.create({ identifier: "turing", root_url: "http://turing.io"})

    payload_1 = { payload: '{
                          "url":"http://turing.io/blog",
                          "requestedAt":"2013-02-16 21:38:28 -0700",
                          "respondedIn":37,
                          "referredBy":"http://turing.io",
                          "requestType":"GET",
                          "parameters":[],
                          "eventName": "socialLogin",
                          "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
                          "resolutionWidth":"1920",
                          "resolutionHeight":"1280",
                          "ip":"63.29.38.211"
                          }'
    }

    payload_2 = { payload: '{
                          "url":"http://turing.io/team",
                          "requestedAt":"2013-02-16 21:38:28 -0700",
                          "respondedIn":37,
                          "referredBy":"http://turing.io",
                          "requestType":"GET",
                          "parameters":[],
                          "eventName": "socialLogin",
                          "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
                          "resolutionWidth":"1920",
                          "resolutionHeight":"1280",
                          "ip":"63.29.38.211"
                          }'
    }

    parser = TrafficSpy::ProcessRequestParser.new

    parsed_string = parser.parse_request(payload_1[:payload])
    rel_path = TrafficSpy::RelativePath.find_or_create_by(path: parsed_string[:relative_path_string])
    parsed_string[:relative_path_id] = rel_path.id
    parsed_string[:application_id] = app.id

    TrafficSpy::Payload.create(parsed_string)

    post '/sources/turing/data', payload_2

    assert_equal 200, last_response.status
  end
end
