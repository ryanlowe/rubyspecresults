require File.dirname(__FILE__) + '/../test_helper'

class TargetTest < ActiveSupport::TestCase
  fixtures :users, :targets
  
  def test_fixtures
    assert targets(:ryanlowe_mri_head)
    assert targets(:ryanlowe_rbx_head)
  end
  
  def test_required_fields
    target_count = Target.count
    
    t = Target.new
    assert_nil t.secret
    assert !t.valid?
    assert_not_nil t.secret
    assert_equal 6, t.errors.size
    assert t.errors.on(:creator)
    assert t.errors.on(:impl)
    assert t.errors.on(:impl_branch)
    assert t.errors.on(:spec_version)
    assert t.errors.on(:arch)
    assert t.errors.on(:os)
    
    t.creator = users(:ryanlowe)
    t.impl = 'MRI'
    t.impl_branch = '1.8.6'
    t.spec_version = '1.8'
    t.arch = 'Intel Core 2 Duo'
    t.os = 'Mac OS X 10.5.4'
    
    assert t.save
    assert_equal target_count+1, Target.count
    
    assert_not_nil t.secret
  end
  
  def test_strip_text_fields
    target_count = Target.count
    
    t = Target.new
    t.creator = users(:ryanlowe)
    t.impl = ' MRI '
    t.impl_branch = ' 1.8.6 '
    t.spec_version = ' 1.8 '
    t.arch = ' Intel Core 2 Duo '
    t.os = ' Mac OS X 10.5.4 '
    t.notes = ' This is special. '
    
    assert t.save
    assert_equal target_count+1, Target.count
    
    assert_equal 'MRI', t.impl
    assert_equal '1.8.6', t.impl_branch
    assert_equal '1.8', t.spec_version
    assert_equal 'Intel Core 2 Duo', t.arch
    assert_equal 'Mac OS X 10.5.4', t.os
    assert_equal 'This is special.', t.notes
  end
  
end
