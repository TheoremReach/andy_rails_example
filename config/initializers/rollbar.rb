# Rollbar.configure do |config|
#   # Without configuration, Rollbar is enabled in all environments.
#   # To disable in specific environments, set config.enabled=false.

#   config.access_token = '117a002ca571459a85afab678905d9e8'

#   if Rails.env.test? || Rails.env.development?
#     config.enabled = false
#   end
  

#   config.exception_level_filters.merge!({'RestClient::Exceptions::OpenTimeout' => 'ignore'})
#   config.exception_level_filters.merge!({'RestClient::Forbidden' => 'ignore'})
#   config.exception_level_filters.merge!({'RestClient::NotFound' => 'ignore'})
  
  
#   # handler = proc do |options|
#   #   ap options
#   #   raise Rollbar::Ignore if any_smart_method(options)
#   # end

#   # Rollbar.configure do |config|
#   #   config.before_process << handler
#   # end

# end
