require './test/test_helper'

class UserCanViewApplicationURLStatisticsTest < FeatureTest
  def add_more_payloads
    payload_data_7 = {
      relative_path_string: "/people",
      requested_at: "2013-02-16 21:38:28 -0700",
      responded_in: 25,
      referred_by:"http://turing.io",
      request_type_string:"GET",
      event_string: "socialLoginB",
      operating_system_string: "Macintosh",
      browser_string: "Mozilla",
      resolution_string: {width: "1366", height: "768"},
      ip_address:"63.29.38.211"
    }
    payload_data_8 = {
      relative_path_string: "/people",
      requested_at: "2013-02-16 21:38:28 -0700",
      responded_in: 26,
      referred_by:"http://facebook.com",
      request_type_string:"GET",
      event_string: "socialLoginB",
      operating_system_string: "Macintosh",
      browser_string: "Mozilla",
      resolution_string: {width: "1366", height: "768"},
      ip_address:"63.29.38.211"
    }
    payload_data_9 = {
      relative_path_string: "/people",
      requested_at: "2013-02-16 21:38:28 -0700",
      responded_in: 35,
      referred_by:"http://facebook.com",
      request_type_string:"POST",
      event_string: "socialLoginB",
      operating_system_string: "Windows",
      browser_string: "Mozilla",
      resolution_string: {width: "1366", height: "768"},
      ip_address:"63.29.38.211"
    }
    payload_data_10 = {
      relative_path_string: "/people",
      requested_at: "2013-02-16 21:38:28 -0700",
      responded_in: 45,
      referred_by:"http://facebook.com",
      request_type_string:"POST",
      event_string: "socialLoginB",
      operating_system_string: "Windows",
      browser_string: "Mozilla",
      resolution_string: {width: "1366", height: "768"},
      ip_address:"63.29.38.211"
    }
    payload_data_11 = {
      relative_path_string: "/people",
      requested_at: "2013-02-16 21:38:28 -0700",
      responded_in: 29,
      referred_by:"http://twitter.com",
      request_type_string:"PUT",
      event_string: "socialLoginB",
      operating_system_string: "RedHat",
      browser_string: "Mozilla",
      resolution_string: {width: "1366", height: "768"},
      ip_address:"63.29.38.211"
    }
    payload_data_12 = {
      relative_path_string: "/people",
      requested_at: "2013-02-16 21:38:28 -0700",
      responded_in: 28,
      referred_by:"http://turing.io",
      request_type_string:"DELETE",
      event_string: "socialLoginB",
      operating_system_string: "Ubuntu",
      browser_string: "Mozilla",
      resolution_string: {width: "1366", height: "768"},
      ip_address:"63.29.38.211"
    }

    payloads = [payload_data_7, payload_data_8, payload_data_9,
                payload_data_10, payload_data_11, payload_data_12]

    app = TrafficSpy::Application.find_by(identifier: "turing")

    payloads.each do |data|
      rel_path = TrafficSpy::RelativePath.find_or_create_by(path: data[:relative_path_string])
      req_type = TrafficSpy::RequestType.find_or_create_by(verb: data[:request_type_string])
      resolution = TrafficSpy::Resolution.find_or_create_by(width: data[:resolution_string][:width],
                                                            height: data[:resolution_string][:height])
      operating_system = TrafficSpy::OperatingSystem.find_or_create_by(op_system: data[:operating_system_string])
      browser = TrafficSpy::Browser.find_or_create_by(browser_name: data[:browser_string])
      event = TrafficSpy::Event.find_or_create_by(event_name: data[:event_string])
      data[:event_id] = event.id
      data[:browser_id] = browser.id
      data[:operating_system_id] = operating_system.id
      data[:resolution_id] = resolution.id
      data[:relative_path_id] = rel_path.id
      data[:request_type_id] = req_type.id
      data[:application_id] = app.id

      [:relative_path_string, :request_type_string, :resolution_string,
       :operating_system_string, :browser_string, :event_string].each { |k| data.delete(k) }

      TrafficSpy::Payload.create(data)
    end
  end

  def test_user_can_view_statistics_for_a_url_blog
    register_turing_and_send_multiple_payloads

    url = '/blog'
    visit "/sources/turing/urls#{url}"

    assert page.has_content?("turing")
    assert page.has_content?("blog")

    within 'tr#longest_response_time' do
      assert page.has_content?("Longest Response Time: 80")
    end

    within 'tr#shortest_response_time' do
      assert page.has_content?("Shortest Response Time: 37")
    end

    within 'tr#average_response_time' do
      assert page.has_content?("Average Response Time: 55.67")
    end

    within 'tr#http_verbs' do
      assert page.has_content?("HTTP Verbs:")
    end

    within 'ol#http_verbs_list li:nth-child(1)' do
      assert page.has_content?("GET (2)")
    end

    within 'ol#http_verbs_list li:nth-child(2)' do
      assert page.has_content?("POST (1)")
    end

    within 'tr#most_pop_referrers' do
      assert page.has_content?("Most Popular Referrers:")
    end

    within 'ol#most_pop_referrers_list li:nth-child(1)' do
      assert page.has_content?("http://turing.io (2)")
    end

    within 'ol#most_pop_referrers_list li:nth-child(2)' do
      assert page.has_content?("http://facebook.com (1)")
    end

    within 'tr#most_pop_os' do
      assert page.has_content?("Most Popular Operating Systems:")
    end

    within 'ol#most_pop_os_list li:nth-child(1)' do
      assert page.has_content?("Macintosh (2)")
    end

    within 'ol#most_pop_os_list li:nth-child(2)' do
      assert page.has_content?("Windows (1)")
    end

    within 'tr#most_pop_browsers' do
      assert page.has_content?("Most Popular Browsers:")
    end

    within 'ol#most_pop_browsers_list li:nth-child(1)' do
      assert page.has_content?("Chrome (1)")
    end

    within 'ol#most_pop_browsers_list li:nth-child(2)' do
      assert page.has_content?("IE10 (1)")
    end

    within 'ol#most_pop_browsers_list li:nth-child(3)' do
      assert page.has_content?("Safari (1)")
    end
  end

  def test_user_can_view_statistics_for_a_url_team
    register_turing_and_send_multiple_payloads

    url = '/team'
    visit "/sources/turing/urls#{url}"

    assert page.has_content?("turing")
    assert page.has_content?("team")

    within 'tr#longest_response_time' do
      assert page.has_content?("Longest Response Time: 41")
    end

    within 'tr#shortest_response_time' do
      assert page.has_content?("Shortest Response Time: 40")
    end

    within 'tr#average_response_time' do
      assert page.has_content?("Average Response Time: 40.5")
    end

    within 'tr#http_verbs' do
      assert page.has_content?("HTTP Verbs:")
    end

    within 'ol#http_verbs_list li:nth-child(1)' do
      assert page.has_content?("GET (2)")
    end

    within 'tr#most_pop_referrers' do
      assert page.has_content?("Most Popular Referrers:")
    end

    within 'ol#most_pop_referrers_list li:nth-child(1)' do
      assert page.has_content?("http://turing.io (2)")
    end

    within 'tr#most_pop_os' do
      assert page.has_content?("Most Popular Operating Systems:")
    end

    within 'ol#most_pop_os_list li:nth-child(1)' do
      assert page.has_content?("Macintosh (1)")
    end

    within 'ol#most_pop_os_list li:nth-child(2)' do
      assert page.has_content?("Windows (1)")
    end

    within 'tr#most_pop_browsers' do
      assert page.has_content?("Most Popular Browsers:")
    end

    within 'ol#most_pop_browsers_list li:nth-child(1)' do
      assert page.has_content?("Chrome (2)")
    end
  end

  def test_user_can_view_statistics_for_a_url_people
    register_turing_and_send_multiple_payloads
    add_more_payloads

    url = '/people'
    visit "/sources/turing/urls#{url}"


    assert page.has_content?("turing")
    assert page.has_content?("people")

    within 'tr#longest_response_time' do
      assert page.has_content?("Longest Response Time: 45")
    end

    within 'tr#shortest_response_time' do
      assert page.has_content?("Shortest Response Time: 25")
    end

    within 'tr#average_response_time' do
      assert page.has_content?("Average Response Time: 31.33")
    end

    within 'tr#http_verbs' do
      assert page.has_content?("HTTP Verbs:")
    end

    within 'ol#http_verbs_list li:nth-child(1)' do
      assert page.has_content?("GET (2)")
    end

    within 'ol#http_verbs_list li:nth-child(2)' do
      assert page.has_content?("POST (2)")
    end

    within 'ol#http_verbs_list li:nth-child(3)' do
      assert page.has_content?("DELETE (1)")
    end

    within 'ol#http_verbs_list li:nth-child(4)' do
      assert page.has_content?("PUT (1)")
    end

    within 'tr#most_pop_referrers' do
      assert page.has_content?("Most Popular Referrers:")
    end

    within 'ol#most_pop_referrers_list li:nth-child(1)' do
      assert page.has_content?("http://facebook.com (3)")
    end
    within 'ol#most_pop_referrers_list li:nth-child(2)' do
      assert page.has_content?("http://turing.io (2)")
    end
    within 'ol#most_pop_referrers_list li:nth-child(3)' do
      assert page.has_content?("http://twitter.com (1)")
    end

    within 'tr#most_pop_os' do
      assert page.has_content?("Most Popular Operating Systems:")
    end

    within 'ol#most_pop_os_list li:nth-child(1)' do
      assert page.has_content?("Macintosh (2)")
    end

    within 'ol#most_pop_os_list li:nth-child(2)' do
      assert page.has_content?("Windows (2)")
    end

    within 'ol#most_pop_os_list li:nth-child(3)' do
      assert page.has_content?("RedHat (1)")
    end

    within 'ol#most_pop_os_list' do
      refute page.has_content?("Ubuntu (1)")
    end

    within 'tr#most_pop_browsers' do
      assert page.has_content?("Most Popular Browsers:")
    end

    within 'ol#most_pop_browsers_list li:nth-child(1)' do
      assert page.has_content?("Mozilla (6)")
    end
  end

  def test_user_sees_only_info_for_one_application
    register_turing_and_send_multiple_payloads

    TrafficSpy::Application.create(identifier: "jumpstartlab", root_url: "http://jumpstartlab.io")

    payload_data = {
      relative_path_string: "/blog",
      requested_at: "2013-02-16 21:38:28 -0700",
      responded_in: 80,
      referred_by:"http://turing.io",
      request_type_string:"GET",
      event_string: "socialLoginC",
      operating_system_string: "Macintosh",
      browser_string: "Chrome",
      resolution_string: {width: "1920", height: "1280"},
      ip_address:"63.29.38.211"
    }

    app = TrafficSpy::Application.find_by(identifier: "jumpstartlab")
    data = TrafficSpy::DataLoader.new(payload_data).find_ids
    data[:application_id] = app.id
    TrafficSpy::Payload.create(data)

    visit '/sources/jumpstartlab/urls/blog'

    within 'ol#http_verbs_list li:nth-child(1)' do
      assert page.has_content?("GET (1)")
    end
  end

  def test_user_sees_error_message_when_path_doesnt_exist_for_identifier
    register_turing_and_send_multiple_payloads

    url = '/beth'
    visit "/sources/turing/urls#{url}"

    assert page.has_content?("turing")
    assert page.has_content?("beth")
    assert page.has_content?("URL has not been requested.")
  end
end
