require './test/test_helper'

class PayloadTest < ModelTest
  def test_can_create_payload_with_valid_parameters
    payload_data = {
      relative_path: "/blog",
      requested_at: "2013-02-16 21:38:28 -0700",
      responded_in: 37,
      referred_by:"http://turing.io",
      request_type:"GET",
      event: "socialLogin",
      operating_system: "Macintosh",
      browser: "Chrome",
      resolution: {width: "1920", height: "1280"},
      ip_address:"63.29.38.211"
      }
    TrafficSpy::Payload.create(payload_data)

    assert_equal 1, TrafficSpy::Payload.count
    assert_nil TrafficSpy::Payload.first.application_id
    assert_equal '/blog', TrafficSpy::Payload.first.relative_path
    assert_equal DateTime.new(2013,02,16,21,38,28, '-0700'), TrafficSpy::Payload.first.requested_at
    assert_equal 37, TrafficSpy::Payload.first.responded_in
    assert_equal 'http://turing.io', TrafficSpy::Payload.first.referred_by
    assert_equal 'GET', TrafficSpy::Payload.first.request_type
    assert_equal 'socialLogin', TrafficSpy::Payload.first.event
    assert_equal 'Macintosh', TrafficSpy::Payload.first.operating_system
    assert_equal 'Chrome', TrafficSpy::Payload.first.browser
    assert_equal '{:width=>"1920", :height=>"1280"}', TrafficSpy::Payload.first.resolution
    assert_equal '63.29.38.211', TrafficSpy::Payload.first.ip_address
  end

  def test_can_create_and_associate_payload_with_valid_parameters
    skip
    TrafficSpy::Application.create(identifier: "turing", root_url: "http://turing.io")

    payload_data = {
      relative_path: "/blog",
      requested_at: "2013-02-16 21:38:28 -0700",
      responded_in: 37,
      referred_by:"http://turing.io",
      request_type:"GET",
      event: "socialLogin",
      operating_system: "Macintosh",
      browser: "Chrome",
      resolution: {width: "1920", height: "1280"},
      ip_address:"63.29.38.211"
      }

    app = TrafficSpy::Application.find_by(identifier: "turing")
    app.payloads.create(payload_data)

    assert_equal 1, TrafficSpy::Payload.count
    assert_equal 1, TrafficSpy::Payload.first.application_id
    assert_equal '/blog', TrafficSpy::Payload.first.relative_path
    assert_equal DateTime.new(2013,02,16,21,38,28, '-0700'), TrafficSpy::Payload.first.requested_at
    assert_equal 37, TrafficSpy::Payload.first.responded_in
    assert_equal 'http://turing.io', TrafficSpy::Payload.first.referred_by
    assert_equal 'GET', TrafficSpy::Payload.first.request_type
    assert_equal 'socialLogin', TrafficSpy::Payload.first.event
    assert_equal 'Macintosh', TrafficSpy::Payload.first.operating_system
    assert_equal 'Chrome', TrafficSpy::Payload.first.browser
    assert_equal '{:width=>"1920", :height=>"1280"}', TrafficSpy::Payload.first.resolution
    assert_equal '63.29.38.211', TrafficSpy::Payload.first.ip_address
  end

  def test_can_create_and_associate_two_payloads_with_valid_unique_parameters
    skip
    TrafficSpy::Application.create(identifier: "turing", root_url: "http://turing.io")

    payload_data_1 = {
      relative_path: "/blog",
      requested_at: "2013-02-16 21:38:28 -0700",
      responded_in: 37,
      referred_by:"http://turing.io",
      request_type:"GET",
      event: "socialLogin",
      operating_system: "Macintosh",
      browser: "Chrome",
      resolution: {width: "1920", height: "1280"},
      ip_address:"63.29.38.211"
    }

    payload_data_2 = {
      relative_path: "/about",
      requested_at: "2013-02-17 21:38:28 -0700",
      responded_in: 40,
      referred_by:"http://turing.io",
      request_type:"GET",
      event: "socialLogin",
      operating_system: "Macintosh",
      browser: "Chrome",
      resolution: {width: "1920", height: "1280"},
      ip_address:"63.29.38.211"
    }

    app = TrafficSpy::Application.find_by(identifier: "turing")

    assert_equal 0, TrafficSpy::Payload.count

    app.payloads.create(payload_data_1)

    assert_equal 1, TrafficSpy::Payload.count

    app.payloads.create(payload_data_2)

    assert_equal 2, TrafficSpy::Payload.count

    assert_equal 1, TrafficSpy::Payload.first.application_id
    assert_equal '/blog', TrafficSpy::Payload.first.relative_path
    assert_equal DateTime.new(2013,02,16,21,38,28, '-0700'), TrafficSpy::Payload.first.requested_at
    assert_equal 37, TrafficSpy::Payload.first.responded_in

    assert_equal 1, TrafficSpy::Payload.last.application_id
    assert_equal '/about', TrafficSpy::Payload.last.relative_path
    assert_equal DateTime.new(2013,02,17,21,38,28, '-0700'), TrafficSpy::Payload.last.requested_at
    assert_equal 40, TrafficSpy::Payload.last.responded_in
  end

  def test_cannot_create_two_payloads_with_exactly_idential_parameters
    skip
    TrafficSpy::Application.create(identifier: "turing", root_url: "http://turing.io")

    payload_data = {
      relative_path: "/blog",
      requested_at: "2013-02-16 21:38:28 -0700",
      responded_in: 37,
      referred_by:"http://turing.io",
      request_type:"GET",
      event: "socialLogin",
      operating_system: "Macintosh",
      browser: "Chrome",
      resolution: {width: "1920", height: "1280"},
      ip_address:"63.29.38.211"
    }

    app = TrafficSpy::Application.find_by(identifier: "turing")

    app.payloads.create(payload_data)
    assert_equal 1, TrafficSpy::Payload.count

    app.payloads.create(payload_data)
    assert_equal 1, TrafficSpy::Payload.count
  end

  def test_creates_second_payload_with_only_unique_application_id
    skip
    TrafficSpy::Application.create(identifier: "turing", root_url: "http://turing.io")
    TrafficSpy::Application.create(identifier: "jumpstartlab", root_url: "http://jumpstartlab.com")

    payload_data = {
      relative_path: "/blog",
      requested_at: "2013-02-16 21:38:28 -0700",
      responded_in: 37,
      referred_by:"http://turing.io",
      request_type:"GET",
      event: "socialLogin",
      operating_system: "Macintosh",
      browser: "Chrome",
      resolution: {width: "1920", height: "1280"},
      ip_address:"63.29.38.211"
    }

    app_turing = TrafficSpy::Application.find_by(identifier: "turing")
    app_jumpstartlab = TrafficSpy::Application.find_by(identifier: "jumpstartlab")

    app_turing.payloads.create(payload_data)
    assert_equal 1, TrafficSpy::Payload.count

    app_jumpstartlab.payloads.create(payload_data)
    assert_equal 2, TrafficSpy::Payload.count
  end

  def test_creates_second_payload_with_only_unique_relative_path
    skip
    TrafficSpy::Application.create(identifier: "turing", root_url: "http://turing.io")

    payload_data_1 = {
      relative_path: "/blog",
      requested_at: "2013-02-16 21:38:28 -0700",
      responded_in: 37,
      referred_by:"http://turing.io",
      request_type:"GET",
      event: "socialLogin",
      operating_system: "Macintosh",
      browser: "Chrome",
      resolution: {width: "1920", height: "1280"},
      ip_address:"63.29.38.211"
    }

    payload_data_2 = {
      relative_path: "/team",
      requested_at: "2013-02-16 21:38:28 -0700",
      responded_in: 37,
      referred_by:"http://turing.io",
      request_type:"GET",
      event: "socialLogin",
      operating_system: "Macintosh",
      browser: "Chrome",
      resolution: {width: "1920", height: "1280"},
      ip_address:"63.29.38.211"
    }

    app = TrafficSpy::Application.find_by(identifier: "turing")

    app.payloads.create(payload_data_1)
    assert_equal 1, TrafficSpy::Payload.count

    app.payloads.create(payload_data_2)
    assert_equal 2, TrafficSpy::Payload.count
  end

  def test_creates_second_payload_with_only_unique_requested_at_time
    skip
    TrafficSpy::Application.create(identifier: "turing", root_url: "http://turing.io")

    payload_data_1 = {
      relative_path: "/blog",
      requested_at: "2013-02-16 21:38:28 -0700",
      responded_in: 37,
      referred_by:"http://turing.io",
      request_type:"GET",
      event: "socialLogin",
      operating_system: "Macintosh",
      browser: "Chrome",
      resolution: {width: "1920", height: "1280"},
      ip_address:"63.29.38.211"
    }

    payload_data_2 = {
      relative_path: "/blog",
      requested_at: "2014-03-25 20:40:13 -0800",
      responded_in: 37,
      referred_by:"http://turing.io",
      request_type:"GET",
      event: "socialLogin",
      operating_system: "Macintosh",
      browser: "Chrome",
      resolution: {width: "1920", height: "1280"},
      ip_address:"63.29.38.211"
    }

    app = TrafficSpy::Application.find_by(identifier: "turing")

    app.payloads.create(payload_data_1)
    assert_equal 1, TrafficSpy::Payload.count

    app.payloads.create(payload_data_2)
    assert_equal 2, TrafficSpy::Payload.count
  end

  def test_creates_second_payload_with_only_unique_responded_in
    skip
    TrafficSpy::Application.create(identifier: "turing", root_url: "http://turing.io")

    payload_data_1 = {
      relative_path: "/blog",
      requested_at: "2013-02-16 21:38:28 -0700",
      responded_in: 37,
      referred_by:"http://turing.io",
      request_type:"GET",
      event: "socialLogin",
      operating_system: "Macintosh",
      browser: "Chrome",
      resolution: {width: "1920", height: "1280"},
      ip_address:"63.29.38.211"
    }

    payload_data_2 = {
      relative_path: "/blog",
      requested_at: "2013-02-16 21:38:28 -0700",
      responded_in: 80,
      referred_by:"http://turing.io",
      request_type:"GET",
      event: "socialLogin",
      operating_system: "Macintosh",
      browser: "Chrome",
      resolution: {width: "1920", height: "1280"},
      ip_address:"63.29.38.211"
    }

    app = TrafficSpy::Application.find_by(identifier: "turing")

    app.payloads.create(payload_data_1)
    assert_equal 1, TrafficSpy::Payload.count

    app.payloads.create(payload_data_2)
    assert_equal 2, TrafficSpy::Payload.count
  end

  def test_creates_second_payload_with_only_unique_referred_by
    skip
    TrafficSpy::Application.create(identifier: "turing", root_url: "http://turing.io")

    payload_data_1 = {
      relative_path: "/blog",
      requested_at: "2013-02-16 21:38:28 -0700",
      responded_in: 37,
      referred_by:"http://turing.io",
      request_type:"GET",
      event: "socialLogin",
      operating_system: "Macintosh",
      browser: "Chrome",
      resolution: {width: "1920", height: "1280"},
      ip_address:"63.29.38.211"
    }

    payload_data_2 = {
      relative_path: "/blog",
      requested_at: "2013-02-16 21:38:28 -0700",
      responded_in: 37,
      referred_by:"http://facebook.com",
      request_type:"GET",
      event: "socialLogin",
      operating_system: "Macintosh",
      browser: "Chrome",
      resolution: {width: "1920", height: "1280"},
      ip_address:"63.29.38.211"
    }

    app = TrafficSpy::Application.find_by(identifier: "turing")

    app.payloads.create(payload_data_1)
    assert_equal 1, TrafficSpy::Payload.count

    app.payloads.create(payload_data_2)
    assert_equal 2, TrafficSpy::Payload.count
  end

  def test_creates_second_payload_with_only_unique_request_type
    skip
    TrafficSpy::Application.create(identifier: "turing", root_url: "http://turing.io")

    payload_data_1 = {
      relative_path: "/blog",
      requested_at: "2013-02-16 21:38:28 -0700",
      responded_in: 37,
      referred_by:"http://turing.io",
      request_type:"GET",
      event: "socialLogin",
      operating_system: "Macintosh",
      browser: "Chrome",
      resolution: {width: "1920", height: "1280"},
      ip_address:"63.29.38.211"
    }

    payload_data_2 = {
      relative_path: "/blog",
      requested_at: "2013-02-16 21:38:28 -0700",
      responded_in: 37,
      referred_by:"http://turing.io",
      request_type:"POST",
      event: "socialLogin",
      operating_system: "Macintosh",
      browser: "Chrome",
      resolution: {width: "1920", height: "1280"},
      ip_address:"63.29.38.211"
    }

    app = TrafficSpy::Application.find_by(identifier: "turing")

    app.payloads.create(payload_data_1)
    assert_equal 1, TrafficSpy::Payload.count

    app.payloads.create(payload_data_2)
    assert_equal 2, TrafficSpy::Payload.count
  end

  def test_creates_second_payload_with_only_unique_event
    skip
    TrafficSpy::Application.create(identifier: "turing", root_url: "http://turing.io")

    payload_data_1 = {
      relative_path: "/blog",
      requested_at: "2013-02-16 21:38:28 -0700",
      responded_in: 37,
      referred_by:"http://turing.io",
      request_type:"GET",
      event: "socialLogin",
      operating_system: "Macintosh",
      browser: "Chrome",
      resolution: {width: "1920", height: "1280"},
      ip_address:"63.29.38.211"
    }

    payload_data_2 = {
      relative_path: "/blog",
      requested_at: "2013-02-16 21:38:28 -0700",
      responded_in: 37,
      referred_by:"http://turing.io",
      request_type:"GET",
      event: "socialShare",
      operating_system: "Macintosh",
      browser: "Chrome",
      resolution: {width: "1920", height: "1280"},
      ip_address:"63.29.38.211"
    }

    app = TrafficSpy::Application.find_by(identifier: "turing")

    app.payloads.create(payload_data_1)
    assert_equal 1, TrafficSpy::Payload.count

    app.payloads.create(payload_data_2)
    assert_equal 2, TrafficSpy::Payload.count
  end

  def test_creates_second_payload_with_only_unique_operating_system
    skip
    TrafficSpy::Application.create(identifier: "turing", root_url: "http://turing.io")

    payload_data_1 = {
      relative_path: "/blog",
      requested_at: "2013-02-16 21:38:28 -0700",
      responded_in: 37,
      referred_by:"http://turing.io",
      request_type:"GET",
      event: "socialLogin",
      operating_system: "Macintosh",
      browser: "Chrome",
      resolution: {width: "1920", height: "1280"},
      ip_address:"63.29.38.211"
    }

    payload_data_2 = {
      relative_path: "/blog",
      requested_at: "2013-02-16 21:38:28 -0700",
      responded_in: 37,
      referred_by:"http://turing.io",
      request_type:"GET",
      event: "socialLogin",
      operating_system: "Windows",
      browser: "Chrome",
      resolution: {width: "1920", height: "1280"},
      ip_address:"63.29.38.211"
    }

    app = TrafficSpy::Application.find_by(identifier: "turing")

    app.payloads.create(payload_data_1)
    assert_equal 1, TrafficSpy::Payload.count

    app.payloads.create(payload_data_2)
    assert_equal 2, TrafficSpy::Payload.count
  end

  def test_creates_second_payload_with_only_unique_browser
    skip
    TrafficSpy::Application.create(identifier: "turing", root_url: "http://turing.io")

    payload_data_1 = {
      relative_path: "/blog",
      requested_at: "2013-02-16 21:38:28 -0700",
      responded_in: 37,
      referred_by:"http://turing.io",
      request_type:"GET",
      event: "socialLogin",
      operating_system: "Macintosh",
      browser: "Chrome",
      resolution: {width: "1920", height: "1280"},
      ip_address:"63.29.38.211"
    }

    payload_data_2 = {
      relative_path: "/blog",
      requested_at: "2013-02-16 21:38:28 -0700",
      responded_in: 37,
      referred_by:"http://turing.io",
      request_type:"GET",
      event: "socialLogin",
      operating_system: "Macintosh",
      browser: "Safari",
      resolution: {width: "1920", height: "1280"},
      ip_address:"63.29.38.211"
    }

    app = TrafficSpy::Application.find_by(identifier: "turing")

    app.payloads.create(payload_data_1)
    assert_equal 1, TrafficSpy::Payload.count

    app.payloads.create(payload_data_2)
    assert_equal 2, TrafficSpy::Payload.count
  end

  def test_creates_second_payload_with_only_unique_resolution
    skip
    TrafficSpy::Application.create(identifier: "turing", root_url: "http://turing.io")

    payload_data_1 = {
      relative_path: "/blog",
      requested_at: "2013-02-16 21:38:28 -0700",
      responded_in: 37,
      referred_by:"http://turing.io",
      request_type:"GET",
      event: "socialLogin",
      operating_system: "Macintosh",
      browser: "Chrome",
      resolution: {width: "1920", height: "1280"},
      ip_address:"63.29.38.211"
    }

    payload_data_2 = {
      relative_path: "/blog",
      requested_at: "2013-02-16 21:38:28 -0700",
      responded_in: 37,
      referred_by:"http://turing.io",
      request_type:"GET",
      event: "socialLogin",
      operating_system: "Macintosh",
      browser: "Chrome",
      resolution: {width: "600", height: "800"},
      ip_address:"63.29.38.211"
    }

    app = TrafficSpy::Application.find_by(identifier: "turing")

    app.payloads.create(payload_data_1)
    assert_equal 1, TrafficSpy::Payload.count

    app.payloads.create(payload_data_2)
    assert_equal 2, TrafficSpy::Payload.count
  end

  def test_creates_second_payload_with_only_unique_ip_address
    skip
    TrafficSpy::Application.create(identifier: "turing", root_url: "http://turing.io")

    payload_data_1 = {
      relative_path: "/blog",
      requested_at: "2013-02-16 21:38:28 -0700",
      responded_in: 37,
      referred_by:"http://turing.io",
      request_type:"GET",
      event: "socialLogin",
      operating_system: "Macintosh",
      browser: "Chrome",
      resolution: {width: "1920", height: "1280"},
      ip_address:"63.29.38.211"
    }

    payload_data_2 = {
      relative_path: "/blog",
      requested_at: "2013-02-16 21:38:28 -0700",
      responded_in: 37,
      referred_by:"http://turing.io",
      request_type:"GET",
      event: "socialLogin",
      operating_system: "Macintosh",
      browser: "Chrome",
      resolution: {width: "1920", height: "1280"},
      ip_address:"99.06.12.836"
    }

    app = TrafficSpy::Application.find_by(identifier: "turing")

    app.payloads.create(payload_data_1)
    assert_equal 1, TrafficSpy::Payload.count

    app.payloads.create(payload_data_2)
    assert_equal 2, TrafficSpy::Payload.count
  end
end
