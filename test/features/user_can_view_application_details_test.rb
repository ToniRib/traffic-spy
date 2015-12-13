require './test/test_helper'

class UserCanViewApplicationDetailsTest < FeatureTest
  def test_user_can_view_most_request_urls
    register_turing_and_send_multiple_payloads

    visit '/sources/turing'

    within 'table#most-requested-urls tr:nth-child(2)' do
      assert page.has_content?('/blog')
      assert page.has_css?("a[href~='/sources/turing/urls/blog']")
      assert page.has_content?(3)
    end

    within 'table#most-requested-urls tr:nth-child(3)' do
      assert page.has_content?('/team')
      assert page.has_css?("a[href~='/sources/turing/urls/team']")
      assert page.has_content?(2)
    end

    within 'table#most-requested-urls tr:nth-child(4)' do
      assert page.has_content?('/about')
      assert page.has_css?("a[href~='/sources/turing/urls/about']")
      assert page.has_content?(1)
    end
  end

  def test_user_can_view_browsers
    register_turing_and_send_multiple_payloads

    visit '/sources/turing'

    within 'table#web-browser tr:nth-child(2)' do
      assert page.has_content?('Chrome')
      assert page.has_content?(3)
    end

    within 'table#web-browser tr:nth-child(3)' do
      assert page.has_content?('IE10')
      assert page.has_content?(1)
    end

    within 'table#web-browser tr:nth-child(4)' do
      assert page.has_content?('Mozilla')
      assert page.has_content?(1)
    end

    within 'table#web-browser tr:nth-child(5)' do
      assert page.has_content?('Safari')
      assert page.has_content?(1)
    end
  end

  def test_user_can_view_operating_systems
    register_turing_and_send_multiple_payloads

    visit '/sources/turing'

    within 'table#operating-system tr:nth-child(2)' do
      assert page.has_content?('Macintosh')
      assert page.has_content?(4)
    end

    within 'table#operating-system tr:nth-child(3)' do
      assert page.has_content?('Windows')
      assert page.has_content?(2)
    end
  end

  def test_user_can_view_screen_resolutions
    register_turing_and_send_multiple_payloads

    visit '/sources/turing'

    within 'table#screen-resolution tr:nth-child(2)' do
      assert page.has_content?(1920)
      assert page.has_content?(1280)
      assert page.has_content?(3)
    end

    within 'table#screen-resolution tr:nth-child(3)' do
      assert page.has_content?(600)
      assert page.has_content?(800)
      assert page.has_content?(1)
    end

    within 'table#screen-resolution tr:nth-child(4)' do
      assert page.has_content?(1366)
      assert page.has_content?(768)
      assert page.has_content?(1)
    end

    within 'table#screen-resolution tr:nth-child(5)' do
      assert page.has_content?(1920)
      assert page.has_content?(1080)
      assert page.has_content?(1)
    end
  end

  def test_user_can_view_average_response_times
    register_turing_and_send_multiple_payloads

    visit '/sources/turing'

    within 'table#average-response-times tr:nth-child(2)' do
      assert page.has_content?('/blog')
      assert page.has_content?(55.67)
    end

    within 'table#average-response-times tr:nth-child(3)' do
      assert page.has_content?('/team')
      assert page.has_content?(40.5)
    end

    within 'table#average-response-times tr:nth-child(4)' do
      assert page.has_content?('/about')
      assert page.has_content?(25.0)
    end
  end

end
