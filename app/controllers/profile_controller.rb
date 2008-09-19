class ProfileController < ApplicationController
  helper :public
  
  def user
    @user = User.find_by_username(params[:username])
    raise ActiveRecord::RecordNotFound if @user.nil?
    @targets = Target.find(:all,:conditions => ["created_by = ?",@user.id], :order => "os, arch")
    @title = @user.username
  end

  def list
    @users = User.find(:all, :order => 'username ASC')
    @title = "People"
  end

end
