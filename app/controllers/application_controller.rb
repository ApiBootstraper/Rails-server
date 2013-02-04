class ApplicationController < ActionController::Base
  protect_from_forgery
#   respond_to :xml, :json, :html

#   unless Rails.application.config.consider_all_requests_local
#     rescue_from ActionController::RoutingError, ActionController::UnknownController,
#                 ::AbstractController::ActionNotFound, with: lambda { |e| render_error e.message, 404 }
#     rescue_from Exception, with: lambda { |e| render_error e.message }
#   end

# private

#   # Return a formated response
#   def respond_with(content, *resources)
#     options = resources.size == 0 ? {} : resources.extract_options!
#     options[:status] = {} if options[:status].nil?

#     # Format status
#     status = {
#       :code    => options[:status][:code] ||= 200,
#       :message => options[:status][:msg] ||= "OK"
#     }
#     options[:status] = status[:code]

#     unless options[:response_header] === false
#       # Format return
#       content = {
#         :header => {
#           :status => status,
#           :request => request.original_fullpath, # escape or stripslahes or sanitize
#         },
#         :response => content
#       }

#       content[:header].merge!({:env => Rails.env}) unless Rails.env.production? # If env is not production, return current env
#     end

#     # Bug fix
#     if request.method != "GET"
#       options[:location] = options[:location] || nil
#     end

#     super(content, options)
#   end

#   # Render with error message
#   def render_error(msg, code=500)
#     respond_with(nil, :status => {:msg => msg, :code => code})
#   end

#   # Render with not found message
#   def render_record_not_found
#     record_name = !controller_name.blank? ? controller_name.singularize.titleize : "Record"
#     respond_with(nil, :status => {:msg => "#{record_name} not found", :code => 404})
#   end

end
