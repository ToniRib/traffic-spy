require_relative "../test_helper"

class UserCanViewApplicationURLStatisticsTest < FeatureTest
  def add_more_payloads
    payload_data_7 = {
      relative_path: "/people",
      requested_at: "2013-02-16 21:38:28 -0700",
      responded_in: 25,
      referred_by:"http://turing.io",
      request_type:"GET",
      event: "socialLoginB",
      operating_system: "Macintosh",
      browser: "Mozilla",
      resolution: {width: "1366", height: "768"},
      ip_address:"63.29.38.211"
    }
    payload_data_8 = {
      relative_path: "/people",
      requested_at: "2013-02-16 21:38:28 -0700",
      responded_in: 26,
      referred_by:"http://facebook.com",
      request_type:"GET",
      event: "socialLoginB",
      operating_system: "Macintosh",
      browser: "Mozilla",
      resolution: {width: "1366", height: "768"},
      ip_address:"63.29.38.211"
    }
    payload_data_9 = {
      relative_path: "/people",
      requested_at: "2013-02-16 21:38:28 -0700",
      responded_in: 35,
      referred_by:"http://facebook.com",
      request_type:"POST",
      event: "socialLoginB",
      operating_system: "Windows",
      browser: "Mozilla",
      resolution: {width: "1366", height: "768"},
      ip_address:"63.29.38.211"
    }
    payload_data_10 = {
      relative_path: "/people",
      requested_at: "2013-02-16 21:38:28 -0700",
      responded_in: 45,
      referred_by:"http://facebook.com",
      request_type:"POST",
      event: "socialLoginB",
      operating_system: "Windows",
      browser: "Mozilla",
      resolution: {width: "1366", height: "768"},
      ip_address:"63.29.38.211"
    }
    payload_data_11 = {
      relative_path: "/people",
      requested_at: "2013-02-16 21:38:28 -0700",
      responded_in: 29,
      referred_by:"http://twitter.com",
      request_type:"PUT",
      event: "socialLoginB",
      operating_system: "RedHat",
      browser: "Mozilla",
      resolution: {width: "1366", height: "768"},
      ip_address:"63.29.38.211"
    }
    payload_data_12 = {
      relative_path: "/people",
      requested_at: "2013-02-16 21:38:28 -0700",
      responded_in: 28,
      referred_by:"http://turing.io",
      request_type:"DELETE",
      event: "socialLoginB",
      operating_system: "Ubuntu",
      browser: "Mozilla",
      resolution: {width: "1366", height: "768"},
      ip_address:"63.29.38.211"
    }

    payloads = [payload_data_7, payload_data_8, payload_data_9,
                payload_data_10, payload_data_11, payload_data_12]

    app = TrafficSpy::Application.find_by(identifier: "turing")

    payloads.each do |data|
      app.payloads.create(data)
    end
  end

  def test_user_can_view_statistics_for_a_url_blog
    register_turing_and_send_multiple_payloads

    url = '/blog'
    visit "/sources/turing/urls#{url}"

    assert page.has_content?("turing")
    assert page.has_content?("blog")

    within 'h5#longest_response_time' do
      assert page.has_content?("Longest Response Time: 80")
    end

    within 'h5#shortest_response_time' do
      assert page.has_content?("Shortest Response Time: 37")
    end

    within 'h5#average_response_time' do
      assert page.has_content?("Average Response Time: 55.67")
    end

    within 'h5#http_verbs' do
      assert page.has_content?("HTTP Verbs:")
    end

    within 'ol#http_verbs_list li:nth-child(1)' do
      assert page.has_content?("GET (2)")
    end

    within 'ol#http_verbs_list li:nth-child(2)' do
      assert page.has_content?("POST (1)")
    end

    within 'h5#most_pop_referrers' do
      assert page.has_content?("Most Popular Referrers:")
    end

    within 'ol#most_pop_referrers_list li:nth-child(1)' do
      assert page.has_content?("http://turing.io (3)")
    end

    within 'h5#most_pop_os' do
      assert page.has_content?("Most Popular Operating Systems:")
    end

    within 'ol#most_pop_os_list li:nth-child(1)' do
      assert page.has_content?("Macintosh (2)")
    end

    within 'ol#most_pop_os_list li:nth-child(2)' do
      assert page.has_content?("Windows (1)")
    end

    within 'h5#most_pop_browsers' do
      assert page.has_content?("Most Popular Browsers:")
    end

    within 'ol#most_pop_browsers_list li:nth-child(1)' do
      assert page.has_content?("Chrome (1)")
    end

    within 'ol#most_pop_browsers_list li:nth-child(2)' do
      assert page.has_content?("Safari (1)")
    end

    within 'ol#most_pop_browsers_list li:nth-child(3)' do
      assert page.has_content?("IE10 (1)")
    end
  end

  def test_user_can_view_statistics_for_a_url_team
    register_turing_and_send_multiple_payloads

    url = '/team'
    visit "/sources/turing/urls#{url}"

    assert page.has_content?("turing")
    assert page.has_content?("team")

    within 'h5#longest_response_time' do
      assert page.has_content?("Longest Response Time: 41")
    end

    within 'h5#shortest_response_time' do
      assert page.has_content?("Shortest Response Time: 40")
    end

    within 'h5#average_response_time' do
      assert page.has_content?("Average Response Time: 40.5")
    end

    within 'h5#http_verbs' do
      assert page.has_content?("HTTP Verbs:")
    end

    within 'ol#http_verbs_list li:nth-child(1)' do
      assert page.has_content?("GET (2)")
    end

    within 'h5#most_pop_referrers' do
      assert page.has_content?("Most Popular Referrers:")
    end

    within 'ol#most_pop_referrers_list li:nth-child(1)' do
      assert page.has_content?("http://turing.io (2)")
    end

    within 'h5#most_pop_os' do
      assert page.has_content?("Most Popular Operating Systems:")
    end

    within 'ol#most_pop_os_list li:nth-child(1)' do
      assert page.has_content?("Windows (1)")
    end

    within 'ol#most_pop_os_list li:nth-child(2)' do
      assert page.has_content?("Macintosh (1)")
    end

    within 'h5#most_pop_browsers' do
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

    within 'h5#longest_response_time' do
      assert page.has_content?("Longest Response Time: 45")
    end

    within 'h5#shortest_response_time' do
      assert page.has_content?("Shortest Response Time: 25")
    end

    within 'h5#average_response_time' do
      assert page.has_content?("Average Response Time: 31.33")
    end

    within 'h5#http_verbs' do
      assert page.has_content?("HTTP Verbs:")
    end

    within 'ol#http_verbs_list li:nth-child(1)' do
      assert page.has_content?("GET (2)")
    end

    within 'ol#http_verbs_list li:nth-child(2)' do
      assert page.has_content?("POST (2)")
    end

    within 'ol#http_verbs_list li:nth-child(3)' do
      assert page.has_content?("PUT (1)")
    end

    within 'ol#http_verbs_list' do
      assert page.has_content?("DELETE (1)")
    end

    within 'h5#most_pop_referrers' do
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

    within 'h5#most_pop_os' do
      assert page.has_content?("Most Popular Operating Systems:")
    end

    within 'ol#most_pop_os_list li:nth-child(1)' do
      assert page.has_content?("Windows (2)")
    end

    within 'ol#most_pop_os_list li:nth-child(2)' do
      assert page.has_content?("Macintosh (2)")
    end

    within 'ol#most_pop_os_list li:nth-child(3)' do
      assert page.has_content?("Ubuntu (1)")
    end

    within 'ol#most_pop_os_list' do
      refute page.has_content?("RedHat (1)")
    end

    within 'h5#most_pop_browsers' do
      assert page.has_content?("Most Popular Browsers:")
    end

    within 'ol#most_pop_browsers_list li:nth-child(1)' do
      assert page.has_content?("Mozilla (6)")
    end
  end

  def test_user_sees_error_message_when_identifier_not_registered
    register_turing_and_send_multiple_payloads

    url = '/beth'
    visit "/sources/turing/urls#{url}"

    assert page.has_content?("turing")
    assert page.has_content?("beth")
    assert page.has_content?("URL has not been requested.")

  end
end