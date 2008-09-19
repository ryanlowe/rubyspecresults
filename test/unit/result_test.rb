require File.dirname(__FILE__) + '/../test_helper'

class ResultTest < ActiveSupport::TestCase
  fixtures :users, :targets, :results

  def test_fixtures
    assert results(:ryanlowe_mri_head1).valid?
  end
  
  def test_required_fields
    result_count = Result.count
    
    r = Result.new
    assert !r.valid?
    assert_equal 8, r.errors.size
    assert r.errors.on(:creator)
    assert r.errors.on(:target)
    assert r.errors.on(:log)
    assert r.errors.on(:files_count)
    assert r.errors.on(:examples_count)
    assert r.errors.on(:expectations_count)
    assert r.errors.on(:failures_count)
    assert r.errors.on(:errors_count)
    
    r.creator = users(:ryanlowe)
    r.target = targets(:ryanlowe_mri_head)
    r.log = "2487 files, 9169 examples, 30818 expectations, 13 failures, 17 errors"
    r.files_count = 2487
    r.examples_count = 9169
    r.expectations_count = 30818
    r.failures_count = 13
    r.errors_count = 17
    
    assert r.save
    assert_equal result_count+1, Result.count
  end
  
  def test_strip_text_fields
    result_count = Result.count
    
    r = Result.new
    r.creator = users(:ryanlowe)
    r.target = targets(:ryanlowe_mri_head)
    r.log = "   2487 files, 9169 examples, 30818 expectations, 13 failures, 17 errors   "
    r.files_count = 2487
    r.examples_count = 9169
    r.expectations_count = 30818
    r.failures_count = 13
    r.errors_count = 17
    
    assert r.save
    assert_equal result_count+1, Result.count
    
    assert_equal '2487 files, 9169 examples, 30818 expectations, 13 failures, 17 errors', r.log
  end
  
end
