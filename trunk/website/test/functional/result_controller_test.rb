require File.dirname(__FILE__) + '/../test_helper'

class ResultControllerTest < ActionController::TestCase
  def test_should_save_posted_result
    report_dir = ResultController::REPORT_DIR
    FileUtils.rm_rf report_dir
    
    data = "sample report"
    post :report, :data => data
    
    assert File.directory?(report_dir)
    assert_equal data, File.open(Dir[File.join(report_dir, "*")].first){|f| f.read}
  end
end
