class ApiController < ApplicationController
  
  def result
    target = Target.find_by_secret(params[:secret])
    if target.nil?
      render_404
      return
    end
    result = Result.new(params[:result])
    result.creator = target.creator
    result.target = target
    unless result.save
      render_404
      return
    end
    render :text => ""
  end
  
end
