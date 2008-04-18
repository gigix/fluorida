class FluoridaController < ApplicationController
  REPORT_DIR = File.join RAILS_ROOT, 'report'
  
  def report
    status = params[:status]
    data = params[:data]
    FileUtils.mkdir_p REPORT_DIR
    
    report_file = File.join REPORT_DIR, Time.now.to_i.to_s
    File.open(report_file, 'w'){|f| f.write data }
    status_file = File.join REPORT_DIR, 'status'
    File.open(status_file, 'w'){|f| f.write status }
        
    render :text => data
  end

  def open
    @suite_url = params[:suite]
  end
end
