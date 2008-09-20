class PublicController < ApplicationController
  helper :profile
  
  def target
    @target = Target.find(params[:id])
    @title = @target.to_s
  end
  
  def result
    @result = Result.find(params[:id])
    @target = @result.target
    @title = @result.to_s
  end
  
end
