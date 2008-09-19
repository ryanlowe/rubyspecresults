module ResultHelper
  def link_result(result,text=nil)
    text = text.nil? ? result.to_s : text
    link_to h(text), :controller => 'result', :action => 'show', :id => result
  end
end
