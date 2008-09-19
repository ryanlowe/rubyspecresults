module PublicHelper
  def public_link_target(target,text=nil)
    text = text.nil? ? target.to_s : text
    link_to h(text), :controller => 'public', :action => 'target', :id => target
  end
  def public_link_result(result,text=nil)
    text = text.nil? ? result.to_s : text
    link_to h(text), :controller => 'public', :action => 'result', :id => result
  end
end
