require './test/test_helper'

class UserCanViewEventSpecificDetails < FeatureTest
  def test_user_can_view_details_from_event_social_login_A
    register_turing_and_send_multiple_payloads

    visit '/sources/turing/events/socialLoginA'
    

    expected = [0, 0, 1, 0, 1, 0,
                0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0]

    page.all('.request-count').each_with_index do |row, idx|
      assert_equal row.text.to_i, expected[idx]
    end

    within '#total-request' do
      assert page.has_content?('Total Requests: 2')
    end
  end

  def test_user_can_view_details_from_event_social_login_B
    register_turing_and_send_multiple_payloads

    visit '/sources/turing/events/socialLoginB'

    expected = [0, 0, 0, 1, 2, 0,
                0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0]

    page.all('.request-count').each_with_index do |row, idx|
      assert_equal row.text.to_i, expected[idx]
    end

    within '#total-request' do
      assert page.has_content?('Total Requests: 3')
    end
  end
end
