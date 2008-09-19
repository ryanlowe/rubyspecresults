require File.dirname(__FILE__) + '/../test_helper'

class TargetControllerTest < ActionController::TestCase
  fixtures :users, :targets
  
  def test_routing
    assert_routing '/my/targets',        :controller => 'target', :action => 'list'
    assert_routing '/my/target/451',     :controller => 'target', :action => 'show',   :id => '451'
    assert_routing '/new/target',        :controller => 'target', :action => 'new'
    assert_routing '/create/target',     :controller => 'target', :action => 'create'
    assert_routing '/edit/target/451',   :controller => 'target', :action => 'edit',   :id => '451'
    assert_routing '/update/target/451', :controller => 'target', :action => 'update', :id => '451'
  end

  #
  # list
  #
  
  def test_list
    login_as :ryanlowe 
  
    get :list
    
    assert_response :success
    assert_template 'list'
    
    assert_equal [ targets(:ryanlowe_mri_head), targets(:ryanlowe_rbx_head) ], assigns(:targets)
  end
  
  def test_list_not_logged_in_launched
    launched true
    
    get :list
    
    assert_response :redirect
    assert_redirected_to login_url
  end
  
  def test_list_not_logged_in_not_launched
    launched false
    
    get :list
    
    assert_response :not_found
  end
  
  #
  # show
  #
  
  def test_show
    assert !targets(:ryanlowe_mri_head).destroyed?
    login_as :ryanlowe 
  
    get :show, :id => targets(:ryanlowe_mri_head)
    
    assert_response :success
    assert_template 'show'
    
    assert_equal targets(:ryanlowe_mri_head), assigns(:target)
  end
  
  def test_show_not_allowed
    login_as :jonny
  
    get :show, :id => targets(:ryanlowe_mri_head)
    
    assert_response :not_found
  end
  
  def test_show_not_logged_in_launched
    launched true
    
    get :show, :id => targets(:ryanlowe_mri_head)
    
    assert_response :redirect
    assert_redirected_to login_url
  end
  
  def test_show_not_logged_in_not_launched
    launched false
    
    get :show, :id => targets(:ryanlowe_mri_head)
    
    assert_response :not_found
  end
  
  def test_show_invalid_id
    assert !Target.exists?(999)
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
    login_as :ryanlowe
  
    get :new
    
    assert_response :success
    assert_template 'new'
    
    assert assigns(:target).new_record?
  end
  
  def test_new_not_logged_in_launched
    launched true
    
    get :new
    
    assert_response :redirect
    assert_redirected_to login_url
  end
  
  def test_new_not_logged_in_not_launched
    launched false
    
    get :new
    
    assert_response :not_found
  end
  
  #
  # create
  #
  
  def test_create
    target_count = Target.count
    login_as :ryanlowe
    
    post :create, :target => { :impl => "MacRuby", :impl_version => "0.3.0", :ruby_version => "1.8.6", :arch => "Intel Core 2 Duo", :os => "Mac OS X 10.5.4" }
    
    assert_equal target_count+1, Target.count
    t = Target.last
    
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => t
    
    assert_equal "MacRuby", t.impl
  end
  
  def test_create_error
    target_count = Target.count
    login_as :ryanlowe
    
    post :create, :target => { }
    
    assert_equal target_count, Target.count
    
    assert_response :success
    assert_template 'new'
  end
  
  def test_create_get
    target_count = Target.count
    login_as :ryanlowe
    
    get :create, :target => { :impl => "MacRuby", :impl_branch => "HEAD", :spec_version => "1.8", :arch => "Intel Core 2 Duo", :os => "Mac OS X 10.5.4" }
    
    assert_equal target_count, Target.count
    
    assert_response :redirect
    assert_redirected_to front_url
  end
  
  def test_create_not_logged_in_launched
    launched true
    
    post :create, :target => { :impl => "MacRuby", :impl_branch => "HEAD", :spec_version => "1.8", :arch => "Intel Core 2 Duo", :os => "Mac OS X 10.5.4" }
    
    assert_response :redirect
    assert_redirected_to login_url
  end
  
  def test_create_not_logged_in_not_launched
    launched false
    
    post :create, :target => { :impl => "MacRuby", :impl_branch => "HEAD", :spec_version => "1.8", :arch => "Intel Core 2 Duo", :os => "Mac OS X 10.5.4" }
    
    assert_response :not_found
  end
  
  #
  # edit
  #
  
  def test_edit
    assert !targets(:ryanlowe_mri_head).destroyed?
    login_as :ryanlowe 
  
    get :edit, :id => targets(:ryanlowe_mri_head)
    
    assert_response :success
    assert_template 'edit'
    
    assert_equal targets(:ryanlowe_mri_head), assigns(:target)
  end
  
  def test_edit_not_allowed
    login_as :jonny
  
    get :edit, :id => targets(:ryanlowe_mri_head)
    
    assert_response :not_found
  end
  
  def test_edit_not_logged_in_launched
    launched true
    
    get :edit, :id => targets(:ryanlowe_mri_head)
    
    assert_response :redirect
    assert_redirected_to login_url
  end
  
  def test_edit_not_logged_in_not_launched
    launched false
    
    get :edit, :id => targets(:ryanlowe_mri_head)
    
    assert_response :not_found
  end
  
  def test_edit_invalid_id
    assert !Target.exists?(999)
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
    assert_equal "MRI", targets(:ryanlowe_mri_head).impl
    login_as :ryanlowe 
  
    post :update, :id => targets(:ryanlowe_mri_head), :target => { :impl => "Matz Ruby Implementation" }
    
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => targets(:ryanlowe_mri_head)
    
    targets(:ryanlowe_mri_head).reload
    assert_equal "Matz Ruby Implementation", targets(:ryanlowe_mri_head).impl
  end
  
  def test_update_error
    assert_equal "MRI", targets(:ryanlowe_mri_head).impl
    login_as :ryanlowe 
  
    post :update, :id => targets(:ryanlowe_mri_head), :target => { :impl => "" }
    
    assert_response :success
    assert_template 'edit'
    
    targets(:ryanlowe_mri_head).reload
    assert_equal "MRI", targets(:ryanlowe_mri_head).impl
  end
  
  def test_update_get
    assert_equal "MRI", targets(:ryanlowe_mri_head).impl
    login_as :ryanlowe 
  
    get :update, :id => targets(:ryanlowe_mri_head), :target => { :impl => "Matz Ruby Implementation" }
    
    assert_response :redirect
    assert_redirected_to front_url
    
    targets(:ryanlowe_mri_head).reload
    assert_equal "MRI", targets(:ryanlowe_mri_head).impl
  end
  
  def test_update_not_allowed
    assert_equal "MRI", targets(:ryanlowe_mri_head).impl
    login_as :brixen
  
    post :update, :id => targets(:ryanlowe_mri_head), :target => { :impl => "Matz Ruby Implementation" }
    
    assert_response :not_found
    
    targets(:ryanlowe_mri_head).reload
    assert_equal "MRI", targets(:ryanlowe_mri_head).impl
  end
  
  def test_update_not_logged_in_launched
    launched true
    assert_equal "MRI", targets(:ryanlowe_mri_head).impl
    
    post :update, :id => targets(:ryanlowe_mri_head), :target => { :impl => "Matz Ruby Implementation" }
    
    assert_response :redirect
    assert_redirected_to login_url
    
    targets(:ryanlowe_mri_head).reload
    assert_equal "MRI", targets(:ryanlowe_mri_head).impl
  end
  
  def test_update_not_logged_in_not_launched
    launched false
    assert_equal "MRI", targets(:ryanlowe_mri_head).impl
    
    post :update, :id => targets(:ryanlowe_mri_head), :target => { :impl => "Matz Ruby Implementation" }
    
    assert_response :not_found
    
    targets(:ryanlowe_mri_head).reload
    assert_equal "MRI", targets(:ryanlowe_mri_head).impl
  end
  
  def test_update_invalid_id
    assert !Target.exists?(999)
    login_as :ryanlowe
  
    assert_raises(ActiveRecord::RecordNotFound) {
      post :update, :id => 999, :target => { :impl => "Matz Ruby Implementation" }
    }
  end
  
  def test_update_no_id
    login_as :ryanlowe 
  
    assert_raises(ActiveRecord::RecordNotFound) {
      post :update, :target => { :impl => "Matz Ruby Implementation" }
    }
  end
  
end
