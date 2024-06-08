require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get pages_index_url
    assert_response :success
  end

  test 'should get 404 on non-existent page' do
    assert_raises(ActionController::RoutingError) do
      get '/pages/non_existent_page'
    end
  end
end
