require './test/test_helper'

class ProcessRequestsTest < ControllerTest
  def test_fails_without_payload
# As a registered app,
  post '/sources', { identifier: "turing", rootUrl: "http://turing.io"}
# When I POST to '/sources/MY_ID/data',
  post "/sources/turing/data"
# And I do not include a payload,
# Then I receive a 400 Bad Request status,
    assert_equal 400, last_response.status
    assert_equal "Payload can't be blank", last_response.body
    assert_equal 0, TrafficSpy::Payload.count
# And I receive a descriptive error
  end

end