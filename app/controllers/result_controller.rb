class ResultController < ApplicationController
  
  before_filter :login_required

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :create, :update, :destroy ],
    :redirect_to => { :controller => 'site', :action => 'front' }
  
  def target
    @target = Target.find(params[:target_id])
    unless @target.created_by?(current_user)
      render_404
      return
    end
    @title = "#{@target.to_s} Results"
  end
  
  def show
    @result = Result.find(params[:id])
    unless @result.created_by?(current_user)
      render_404
      return
    end
    @target = @result.target
    @title = @result.to_s
  end
  
  def new
    @target = Target.find(params[:target_id])
    unless @target.created_by?(current_user)
      render_404
      return
    end
    @result = Result.new
    @title = "New Result for #{@target.to_s}"
  end
  
  def create
    @target = Target.find(params[:target_id])
    unless @target.created_by?(current_user)
      render_404
      return
    end
    @result = Result.new(params[:result])
    @result.creator = current_user
    @result.target = @target
    if @result.save
      flash[:notice] = "Result was created"
      redirect_to :action => 'show', :id => @result
    else
      @title = "New Result for #{@target.to_s}"
      render :action => 'new'
    end
  end
  
  def edit
    @result = Result.find(params[:id])
    unless @result.created_by?(current_user)
      render_404
      return
    end
    @target = @result.target
    @title = "Edit Result"
  end
  
  def update
    @result = Result.find(params[:id])
    unless @result.created_by?(current_user)
      render_404
      return
    end
    if @result.update_attributes(params[:result])
      flash[:notice] = "Result changes were saved"
      redirect_to :action => 'show', :id => @result
    else
      @target = @result.target
      @title = "Edit Result"
      render :action => 'edit'
    end
  end
  
end
