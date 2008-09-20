# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.action_view.cache_template_loading            = true

# Use a different cache store in production
# config.cache_store = :mem_cache_store

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false

HOST = "rubyspecresults.org"

ANALYTICS = '<script type="text/javascript">'+"\n"+
            'var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");'+"\n"+
            'document.write(unescape("%3Cscript src=\'" + gaJsHost + "google-analytics.com/ga.js\' type=\'text/javascript\'%3E%3C/script%3E"));'+"\n"+
            '</script>'+"\n"+
            '<script type="text/javascript">'+"\n"+
            'var pageTracker = _gat._getTracker("UA-2716497-2");'+"\n"+
            'pageTracker._trackPageview();'+"\n"+
            '</script>'
