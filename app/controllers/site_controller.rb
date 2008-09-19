class SiteController < ApplicationController
  helper :profile
  helper :public
  
  skip_before_filter :launch_required

  def boom
    raise "boom!"
  end

  def front
  end

end
