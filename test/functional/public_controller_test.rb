require File.dirname(__FILE__) + '/../test_helper'

class PublicControllerTest < ActionController::TestCase
  fixtures :users, :targets, :results
  
  def test_routing
    assert_routing '/target/73', :controller => 'public', :action => 'target', :id => '73'
    assert_routing '/result/91', :controller => 'public', :action => 'result', :id => '91'
  end
  
  #
  # target
  #
  
  def test_target
    assert !targets(:ryanlowe_mri_head).destroyed?
    login_as :ryanlowe 
  
    get :target, :id => targets(:ryanlowe_mri_head)
    
    assert_response :success
    assert_template 'target'
    
    assert_equal targets(:ryanlowe_mri_head), assigns(:target)
  end
  
  def test_target_not_logged_in_launched
    launched true
    
    get :target, :id => targets(:ryanlowe_mri_head)
    
    assert_response :success
    assert_template 'target'
    
    assert_equal targets(:ryanlowe_mri_head), assigns(:target)
  end
  
  def test_target_not_logged_in_not_launched
    launched false
    
    get :target, :id => targets(:ryanlowe_mri_head)
    
    assert_response :not_found
  end
  
  def test_target_invalid_id
    assert !Target.exists?(999)
    login_as :ryanlowe
  
    assert_raises(ActiveRecord::RecordNotFound) {
      get :target, :id => 999
    }
  end
  
  def test_target_no_id
    login_as :ryanlowe 
  
    assert_raises(ActiveRecord::RecordNotFound) {
      get :target
    }
  end

  #
  # result
  #
  
  def test_result
    assert !targets(:ryanlowe_mri_head).destroyed?
    assert !results(:ryanlowe_mri_head1).destroyed?
    login_as :ryanlowe 
  
    get :result, :id => results(:ryanlowe_mri_head1)
    
    assert_response :success
    assert_template 'result'
    
    assert_equal results(:ryanlowe_mri_head1), assigns(:result)
  end
  
  def test_result_not_logged_in_launched
    launched true
    
    get :result, :id => results(:ryanlowe_mri_head1)
    
    assert_response :success
    assert_template 'result'
    
    assert_equal results(:ryanlowe_mri_head1), assigns(:result)
  end
  
  def test_result_not_logged_in_not_launched
    launched false
    
    get :result, :id => results(:ryanlowe_mri_head1)
    
    assert_response :not_found
  end
  
  def test_result_invalid_id
    assert !Result.exists?(999)
    login_as :ryanlowe
  
    assert_raises(ActiveRecord::RecordNotFound) {
      get :result, :id => 999
    }
  end
  
  def test_result_no_id
    login_as :ryanlowe 
  
    assert_raises(ActiveRecord::RecordNotFound) {
      get :result
    }
  end
  
end
