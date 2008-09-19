class TargetController < ApplicationController
  
  before_filter :login_required

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :create, :update, :destroy ],
    :redirect_to => { :controller => 'site', :action => 'front' }

  def list
    @targets = current_user.targets
    @title = "My Targets"
  end

  def show
    @target = Target.find(params[:id])
    unless @target.created_by?(current_user)
      render_404
      return
    end
    @title = "My "+@target.to_s
  end

  def new
    @target = Target.new
    @title = "New Target"
  end
  
  def create
    @target = Target.new(params[:target])
    @target.creator = current_user
    if @target.save
      flash[:notice] = "Target was created"
      redirect_to :action => 'show', :id => @target
    else
      @title = "New Target"
      render :action => 'new'
    end
  end

  def edit
    @target = Target.find(params[:id])
    unless @target.created_by?(current_user)
      render_404
      return
    end
    @title = "Edit Target"
  end
  
  def update
    @target = Target.find(params[:id])
    unless @target.created_by?(current_user)
      render_404
      return
    end
    @target.valid?
    print @target.errors.full_messages.join(",")
    if @target.update_attributes(params[:target])
      flash[:notice] = "Target changes were saved"
      redirect_to :action => 'show', :id => @target
    else
      @title = "Edit Target"
      render :action => 'edit'
    end
  end

end
