require File.dirname(__FILE__) + '/../test_helper'

class ResultControllerTest < ActionController::TestCase
  fixtures :users, :targets, :results
  
  def test_routing
    assert_routing '/my/target/777/results',    :controller => 'result', :action => 'target', :target_id => '777'
    assert_routing '/my/result/91',             :controller => 'result', :action => 'show',   :id => '91'
    assert_routing '/target/777/new/result',    :controller => 'result', :action => 'new',    :target_id => '777'
    assert_routing '/target/777/create/result', :controller => 'result', :action => 'create', :target_id => '777'
    assert_routing '/edit/result/91',           :controller => 'result', :action => 'edit',   :id => '91'
    assert_routing '/update/result/91',         :controller => 'result', :action => 'update', :id => '91'
  end
  
  #
  # target
  #
  
  def test_target
    assert !targets(:ryanlowe_mri_head).destroyed?
    login_as :ryanlowe 
  
    get :target, :target_id => targets(:ryanlowe_mri_head)
    
    assert_response :success
    assert_template 'target'
    
    assert_equal targets(:ryanlowe_mri_head), assigns(:target)
  end
  
  def test_target_not_allowed
    login_as :brixen
  
    get :target, :target_id => targets(:ryanlowe_mri_head)
    
    assert_response :not_found
  end
  
  def test_target_not_logged_in_launched
    launched true
    
    get :target, :target_id => targets(:ryanlowe_mri_head)
    
    assert_response :redirect
    assert_redirected_to login_url
  end
  
  def test_target_not_logged_in_not_launched
    launched false
    
    get :target, :target_id => targets(:ryanlowe_mri_head)
    
    assert_response :not_found
  end
  
  def test_target_invalid_target_id
    assert !Target.exists?(999)
    login_as :ryanlowe
  
    assert_raises(ActiveRecord::RecordNotFound) {
      get :target, :target_id => 999
    }
  end
  
  def test_target_no_id
    login_as :ryanlowe 
  
    assert_raises(ActionController::RoutingError) {
      get :target
    }
  end
  
  #
  # show
  #
  
  def test_show
    assert !targets(:ryanlowe_mri_head).destroyed?
    assert !results(:ryanlowe_mri_head1).destroyed?
    login_as :ryanlowe 
  
    get :show, :id => results(:ryanlowe_mri_head1)
    
    assert_response :success
    assert_template 'show'
    
    assert_equal targets(:ryanlowe_mri_head), assigns(:target)
    assert_equal results(:ryanlowe_mri_head1), assigns(:result)
  end
  
  def test_show_not_allowed
    login_as :brixen
  
    get :show, :id => results(:ryanlowe_mri_head1)
    
    assert_response :not_found
  end
  
  def test_show_not_logged_in_launched
    launched true
    
    get :show, :id => results(:ryanlowe_mri_head1)
    
    assert_response :redirect
    assert_redirected_to login_url
  end
  
  def test_show_not_logged_in_not_launched
    launched false
    
    get :show, :id => results(:ryanlowe_mri_head1)
    
    assert_response :not_found
  end
  
  def test_show_invalid_id
    assert !Result.exists?(999)
    login_as :ryanlowe
  
    assert_raises(ActiveRecord::RecordNotFound) {
      get :show, :id => 999
    }
  end
  
  def test_show_no_id
    login_as :ryanlowe 
  
    assert_raises(ActiveRecord::RecordNotFound) {
      get :show
    }
  end
  
  #
  # new
  #
  
  def test_new
    assert !targets(:ryanlowe_mri_head).destroyed?
    login_as :ryanlowe 
  
    get :new, :target_id => targets(:ryanlowe_mri_head)
    
    assert_response :success
    assert_template 'new'
    
    assert_equal targets(:ryanlowe_mri_head), assigns(:target)
    assert assigns(:result).new_record?
  end
  
  def test_new_not_allowed
    login_as :brixen
  
    get :new, :target_id => targets(:ryanlowe_mri_head)
    
    assert_response :not_found
  end
  
  def test_new_not_logged_in_launched
    launched true
    
    get :new, :target_id => targets(:ryanlowe_mri_head)
    
    assert_response :redirect
    assert_redirected_to login_url
  end
  
  def test_new_not_logged_in_not_launched
    launched false
    
    get :new, :target_id => targets(:ryanlowe_mri_head)
    
    assert_response :not_found
  end
  
  def test_new_invalid_id
    assert !Target.exists?(999)
    login_as :ryanlowe
  
    assert_raises(ActiveRecord::RecordNotFound) {
      get :new, :target_id => 999
    }
  end
  
  def test_new_no_id
    login_as :ryanlowe 
  
    assert_raises(ActionController::RoutingError) {
      get :new
    }
  end
  
  #
  # create
  #
  
  def test_create
    target_count = Target.count
    result_count = Result.count
    login_as :ryanlowe
    
    post :create, :target_id => targets(:ryanlowe_mri_head), :result => { :log => "2487 files, 9169 examples, 30818 expectations, 13 failures, 17 errors" }
    
    assert_equal target_count, Target.count
    assert_equal result_count+1, Result.count
    r = Result.last
    
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => r
    
    assert_equal users(:ryanlowe), r.creator
    assert_equal targets(:ryanlowe_mri_head), r.target
    assert_equal "2487 files, 9169 examples, 30818 expectations, 13 failures, 17 errors", r.log
  end
  
  def test_create_not_target_creator
    target_count = Target.count
    result_count = Result.count
    login_as :brixen
    
    post :create, :target_id => targets(:ryanlowe_mri_head), :result => { :log => "2487 files, 9169 examples, 30818 expectations, 13 failures, 17 errors" }
    
    assert_equal target_count, Target.count
    assert_equal result_count, Result.count
    
    assert_response :not_found
  end
  
  def test_create_error
    result_count = Result.count
    login_as :ryanlowe
    
    post :create, :target_id => targets(:ryanlowe_mri_head), :result => { :log => "" }
    
    assert_equal result_count, Result.count
    
    assert_response :success
    assert_template 'new'
  end
  
  def test_create_get
    result_count = Result.count
    login_as :ryanlowe
    
    get :create, :target_id => targets(:ryanlowe_mri_head), :result => { :log => "2487 files, 9169 examples, 30818 expectations, 13 failures, 17 errors" }
    
    assert_equal result_count, Result.count
    
    assert_response :redirect
    assert_redirected_to front_url
  end
  
  def test_create_not_logged_in_launched
    launched true
    
    post :create, :target_id => targets(:ryanlowe_mri_head), :result => { :log => "2487 files, 9169 examples, 30818 expectations, 13 failures, 17 errors" }
    
    assert_response :redirect
    assert_redirected_to login_url
  end
  
  def test_create_not_logged_in_not_launched
    launched false
    
    post :create, :target_id => targets(:ryanlowe_mri_head), :result => { :log => "2487 files, 9169 examples, 30818 expectations, 13 failures, 17 errors" }
    
    assert_response :not_found
  end
  
  def test_create_no_target_id
    result_count = Result.count
    login_as :ryanlowe
    
    assert_raises(ActionController::RoutingError) {
      post :create, :result => { :log => "2487 files, 9169 examples, 30818 expectations, 13 failures, 17 errors" }
    }
    
    assert_equal result_count, Result.count    
  end
  
  def test_create_no_result
    result_count = Result.count
    login_as :ryanlowe
    
    post :create, :target_id => targets(:ryanlowe_mri_head)
    
    assert_equal result_count, Result.count
    
    assert_response :success
    assert_template 'new'
  end
  
  #
  # edit
  #
  
  def test_edit
    assert !targets(:ryanlowe_mri_head).destroyed?
    assert !results(:ryanlowe_mri_head1).destroyed?
    login_as :ryanlowe 
  
    get :edit, :id => results(:ryanlowe_mri_head1)
    
    assert_response :success
    assert_template 'edit'
    
    assert_equal targets(:ryanlowe_mri_head), assigns(:target)
    assert_equal results(:ryanlowe_mri_head1), assigns(:result)
  end
  
  def test_edit_not_allowed
    login_as :brixen
  
    get :edit, :id => results(:ryanlowe_mri_head1)
    
    assert_response :not_found
  end
  
  def test_edit_not_logged_in_launched
    launched true
    
    get :edit, :id => results(:ryanlowe_mri_head1)
    
    assert_response :redirect
    assert_redirected_to login_url
  end
  
  def test_edit_not_logged_in_not_launched
    launched false
    
    get :edit, :id => results(:ryanlowe_mri_head1)
    
    assert_response :not_found
  end
  
  def test_edit_invalid_id
    assert !Result.exists?(999)
    login_as :ryanlowe
  
    assert_raises(ActiveRecord::RecordNotFound) {
      get :edit, :id => 999
    }
  end
  
  def test_edit_no_id
    login_as :ryanlowe 
  
    assert_raises(ActiveRecord::RecordNotFound) {
      get :edit
    }
  end
  
  #
  # update
  #
  
  def test_update
    assert_equal "2487 files, 9169 examples, 30818 expectations, 13 failures, 17 errors", results(:ryanlowe_mri_head1).log
    login_as :ryanlowe 
  
    post :update, :id => results(:ryanlowe_mri_head1), :result => { :log => "0 files, 0 examples, 0 expectations, 0 failures, 0 errors" }
    
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => results(:ryanlowe_mri_head1)
    
    results(:ryanlowe_mri_head1).reload
    assert_equal "0 files, 0 examples, 0 expectations, 0 failures, 0 errors", results(:ryanlowe_mri_head1).log
  end
  
  def test_update_error
    assert_equal "2487 files, 9169 examples, 30818 expectations, 13 failures, 17 errors", results(:ryanlowe_mri_head1).log
    login_as :ryanlowe 
  
    post :update, :id => results(:ryanlowe_mri_head1), :result => { :log => "" }
    
    assert_response :success
    assert_template 'edit'
    
    results(:ryanlowe_mri_head1).reload
    assert_equal "2487 files, 9169 examples, 30818 expectations, 13 failures, 17 errors", results(:ryanlowe_mri_head1).log
  end
  
  def test_update_get
    assert_equal "2487 files, 9169 examples, 30818 expectations, 13 failures, 17 errors", results(:ryanlowe_mri_head1).log
    login_as :ryanlowe 
  
    get :update, :id => results(:ryanlowe_mri_head1), :result => { :log => "0 files, 0 examples, 0 expectations, 0 failures, 0 errors" }
    
    assert_response :redirect
    assert_redirected_to front_url
    
    results(:ryanlowe_mri_head1).reload
    assert_equal "2487 files, 9169 examples, 30818 expectations, 13 failures, 17 errors", results(:ryanlowe_mri_head1).log
  end
  
  def test_update_not_allowed
    assert_equal "2487 files, 9169 examples, 30818 expectations, 13 failures, 17 errors", results(:ryanlowe_mri_head1).log
    login_as :jonny
  
    post :update, :id => results(:ryanlowe_mri_head1), :result => { :log => "0 files, 0 examples, 0 expectations, 0 failures, 0 errors" }
    
    assert_response :not_found
    
    results(:ryanlowe_mri_head1).reload
    assert_equal "2487 files, 9169 examples, 30818 expectations, 13 failures, 17 errors", results(:ryanlowe_mri_head1).log
  end
  
  def test_update_not_logged_in_launched
    launched true
    assert_equal "2487 files, 9169 examples, 30818 expectations, 13 failures, 17 errors", results(:ryanlowe_mri_head1).log
    
    post :update, :id => results(:ryanlowe_mri_head1), :result => { :log => "0 files, 0 examples, 0 expectations, 0 failures, 0 errors" }
    
    assert_response :redirect
    assert_redirected_to login_url
    
    results(:ryanlowe_mri_head1).reload
    assert_equal "2487 files, 9169 examples, 30818 expectations, 13 failures, 17 errors", results(:ryanlowe_mri_head1).log
  end
  
  def test_update_not_logged_in_not_launched
    launched false
    assert_equal "2487 files, 9169 examples, 30818 expectations, 13 failures, 17 errors", results(:ryanlowe_mri_head1).log
    
    post :update, :id => results(:ryanlowe_mri_head1), :result => { :log => "0 files, 0 examples, 0 expectations, 0 failures, 0 errors" }
    
    assert_response :not_found
    
    results(:ryanlowe_mri_head1).reload
    assert_equal "2487 files, 9169 examples, 30818 expectations, 13 failures, 17 errors", results(:ryanlowe_mri_head1).log
  end
  
  def test_update_invalid_id
    assert !Target.exists?(999)
    login_as :ryanlowe
  
    assert_raises(ActiveRecord::RecordNotFound) {
      post :update, :id => 999, :result => { :log => "0 files, 0 examples, 0 expectations, 0 failures, 0 errors" }
    }
  end
  
  def test_update_no_id
    login_as :ryanlowe 
  
    assert_raises(ActiveRecord::RecordNotFound) {
      post :update, :result => { :log => "0 files, 0 examples, 0 expectations, 0 failures, 0 errors" }
    }
  end
  
end
