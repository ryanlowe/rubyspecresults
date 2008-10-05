require File.dirname(__FILE__) + '/../test_helper'

class ApiControllerTest < ActionController::TestCase
  fixtures :users, :targets, :results
  
  def test_routing
    assert_routing '/api/add/result', :controller => 'api', :action => 'result'
  end
  
  #
  # result
  #
  
  def test_result
    result_count = Result.count
    
    post :result, :secret => targets(:ryanlowe_mri_head).secret, :result => { :files_count => 1328, :examples_count => 5882, :expectations_count => 21363, :failures_count => 0, :errors_count => 0, :log => "1328 files, 5882 examples, 21363 expectations, 0 failures, 0 errors" }
    
    assert_response :success
    assert_equal 0, @response.body.length
    
    assert_equal result_count+1, Result.count
  end
  
  def test_result_error
    result_count = Result.count
    
    post :result, :secret => targets(:ryanlowe_mri_head).secret, :result => {}
    
    assert_response :not_found
    
    assert_equal result_count, Result.count
  end
  
  def test_result_invalid_secret
    result_count = Result.count
    assert_nil Target.find_by_secret('zzzz')
    
    post :result, :secret => 'zzzz'
    
    assert_response :not_found
    
    assert_equal result_count, Result.count
  end
  
  def test_result_no_secret
    result_count = Result.count
    
    post :result
    
    assert_response :not_found
    
    assert_equal result_count, Result.count
  end
  
end
