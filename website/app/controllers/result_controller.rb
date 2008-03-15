class ResultController < ApplicationController
  skip_before_filter :verify_authenticity_token  
  REPORT_DIR = File.join RAILS_ROOT, 'report'
  
  def report
    data = params[:data]
    FileUtils.mkdir_p REPORT_DIR
    report_file = File.join REPORT_DIR, Time.now.to_i.to_s
    File.open(report_file, "w") do |f|
      f.write data
    end
    render :text => data
  end
end
