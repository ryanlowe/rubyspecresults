ActionController::Routing::Routes.draw do |map|

  #site
  map.with_options :controller => "site" do |site|
    site.connect '/boom',  :action => 'boom'
    site.front   '/',      :action => 'front'
    site.about   '/about', :action => 'about'
  end
  
  #account
  map.with_options :controller => "account" do |account|
    account.connect '/account', :action => 'index'
    account.login   '/login',   :action => 'login'
    account.signup  '/signup',  :action => 'signup'
    account.logout  '/logout',  :action => 'logout'
  end
  
  #settings
  map.with_options :controller => "settings" do |settings|
    settings.preferences     '/settings/preferences',        :action => 'preferences'
    settings.connect         '/settings/update/preferences', :action => 'update_preferences'
    settings.change_password '/settings/change/password',    :action => 'change_password'
    settings.connect         '/settings/update/password',    :action => 'update_password'
  end
  
  #home
  map.with_options :controller => "home" do |home|
    home.home '/home', :action => 'index'
  end

  #messages
  map.with_options :controller => "messages" do |messages|
    messages.inbox   '/inbox',                  :action => 'inbox'
    messages.outbox  '/outbox',                 :action => 'outbox'
    messages.trash   '/trash',                  :action => 'trash'
    messages.connect '/incoming/:id',           :action => 'incoming'
    messages.connect '/outgoing/:id',           :action => 'outgoing'
    messages.connect '/send/message/to/:id',    :action => 'new'
    messages.connect '/reply/to/message/:id',   :action => 'reply'
    messages.connect '/create/message/to/:id',  :action => 'create'
    messages.connect '/destroy/incoming/:id',   :action => 'destroy'
    messages.connect '/undestroy/incoming/:id', :action => 'undestroy'
  end
  
  ###
  
  #result
  map.with_options :controller => "result" do |result|
    result.connect '/my/target/:target_id/results', :action => 'target'
    result.connect '/my/result/:id',                :action => 'show'
    result.connect '/target/:target_id/new/result',    :action => 'new'
    result.connect '/target/:target_id/create/result', :action => 'create'
    result.connect '/edit/result/:id',           :action => 'edit'
    result.connect '/update/result/:id',         :action => 'update'
  end
  
  #target
  map.with_options :controller => "target" do |target|
    target.my_targets '/my/targets',        :action => 'list'
    target.connect    '/my/target/:id',     :action => 'show'
    target.new_target '/new/target',        :action => 'new'
    target.connect    '/create/target',     :action => 'create'
    target.connect    '/edit/target/:id',   :action => 'edit'
    target.connect    '/update/target/:id', :action => 'update'
  end
  
  ### PUBLIC AREAS
  
  #public
  map.with_options :controller => "public" do |public_c|
    public_c.connect '/target/:id', :action => 'target'
    public_c.connect '/result/:id', :action => 'result'
  end
  
  #profile
  map.with_options :controller => "profile" do |profile|
    profile.connect '/person/:username', :action => 'user'
    profile.people  '/people',           :action => 'list'
  end
  
  ### ADMIN
  
  #admin_users
  map.with_options :controller => "admin_users" do |admin_users|
    admin_users.admin_users '/admin/users',    :action => 'list'
    admin_users.connect     '/admin/user/:id', :action => 'show'
  end

end
