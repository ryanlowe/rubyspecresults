module TargetHelper
  def link_target(target,text=nil)
    text = text.nil? ? target.to_s : text
    link_to h(text), :controller => 'target', :action => 'show', :id => target
  end
end
