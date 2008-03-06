class TesterController < ApplicationController
  def open
    @suite_url = params[:suite]
  end
end
