require './test/test_helper'

class ProcessRequestParserTest < ModelTest
  def test_parse_request_returns_hash
    string = '{
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
    parser = TrafficSpy::ProcessRequestParser.new

    expected = {
      relative_path_string: "/blog",
      requested_at: "2013-02-16 21:38:28 -0700",
      responded_in: 37,
      referred_by:"http://turing.io",
      request_type_string:"GET",
      event: "socialLogin",
      operating_system_string: "Macintosh",
      browser_string: "Chrome",
      resolution_string: {width: "1920", height: "1280"},
      ip_address:"63.29.38.211"
      }

    assert_equal expected, parser.parse_request(string)
  end
end
