class SiteController < ApplicationController
  helper :profile
  helper :public
  
  skip_before_filter :launch_required

  def boom
    raise "boom!"
  end

  def front
    @targets = Target.find(:all,:order => "os, arch")
  end
  
  def about
    @title = "About RubySpecResults"
  end

end
