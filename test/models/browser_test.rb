require './test/test_helper'

class OperatingSystemTest < ModelTest
  def test_create_browser_with_valid_parameters
    payload_data = {
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

    browser = TrafficSpy::Browser.find_or_create_by(browser_name: payload_data[:browser_string])
    assert_equal 1, TrafficSpy::Browser.count
    assert_equal "Chrome", browser.browser_name
  end
end
