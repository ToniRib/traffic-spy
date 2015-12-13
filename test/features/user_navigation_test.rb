require './test/test_helper'

class UserNavigationLinks < FeatureTest

  def test_user_navbar_functionality 
    register_turing_and_send_multiple_payloads
    visit '/'

    within 'nav#navbar-link' do
      click_link "TrafficSpy"
      assert "/", current_path
    end

    within 'nav#navbar-link' do
      click_link "HomePage"
      assert "/", current_path
    end

    within 'nav#navbar-link' do
      click_link "Registered Applications"
      assert "/sources", current_path
    end
  end 
  
  def test_user_redirected_to_details_by_registered_app_link
    register_turing_and_send_multiple_payloads

    visit '/sources'

    within 'ul.center#registered-app-index' do
      click_link "turing"
    end

    assert "/sources/turing", current_path
  end 

  def test_user_redicted_to_url_stats_by_details_link
    register_turing_and_send_multiple_payloads

    visit '/sources/turing'

    within 'table#most-requested-urls tr:nth-child(2)' do
      assert page.has_content?('/blog')
      click_link "/blog"
    end

    assert "/sources/turing/urls/blog", current_path
  end 

  def test_user_redirected_to_event_index_from_details_event_data_link
    register_turing_and_send_multiple_payloads

    visit '/sources/turing'

    within 'h5.card-title#aggregate-event' do
      assert page.has_content?('Aggregate Event Data')
      click_link "Aggregate Event Data"
    end

    assert "/sources/turing/events", current_path
  end 

  def test_user_redirected_to_event_details_from_event_index
    register_turing_and_send_multiple_payloads

    visit '/sources/turing/events'

    within 'li#event-index-links:nth-child(1)' do
      assert page.has_content?('socialLoginB')
      click_link "socialLoginB"
    end

    assert "/sources/turing/events/socialLoginB", current_path
  end 

end 