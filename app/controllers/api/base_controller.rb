class Api::BaseController < ApplicationController
  session :disabled => true

  # Set respond format
  respond_to :xml, :json

  # Set filters
  skip_before_filter :verify_authenticity_token
  before_filter :set_default_response_format,
                :generate_presenter
  around_filter :catch_exceptions

  # Responders
  responders :json

  # Accessors
  attr_reader :presenter

protected

  # Get the current version
  def current_version
    v = nil
    v = (self.class.name.split("::").first(2).join("::") + '::VERSION').constantize unless defined?((self.class.name.split("::").first(2).join("::") + '::VERSION').constantize.to_s).nil?
    env['tracking'].current_version = v
    return v
  end

  # Instanciate Presenter class if exist
  def generate_presenter
    @presenter = nil
    @presenter = ((self.class.name.gsub!('Controller', '').singularize + 'Presenter').constantize).new unless defined?((self.class.name.gsub!('Controller', '').singularize + 'Presenter').constantize.to_s).nil?
  end

  # Returns offset and limit used to retrieve objects
  # for an API response based on offset, limit and page parameters
  # (See: https://github.com/redmine/redmine/blob/2.2-stable/app/controllers/application_controller.rb#L470)
  def api_offset_and_limit(options=params)
    offset = 0

    if options[:offset].present?
      offset = options[:offset].to_i
      offset = 0 if offset < 0
    end

    limit = options[:limit].to_i
    if limit < 1
      limit = 25
    elsif limit > 100
      limit = 100
    end

    if offset.nil? && options[:page].present?
      offset = (options[:page].to_i - 1) * limit
      offset = 0 if offset < 0
    end

    [offset, limit]
  end

  # Return a formated response
  def respond_with(content, *resources)
    options = resources.size == 0 ? {} : resources.extract_options!
    options[:status] = {} if options[:status].nil?

    # Format status
    status = {
      :code => options[:status][:code] ||= 200,
      :msg  => options[:status][:msg]  ||= "OK"
    }
    options[:status] = status[:code]

    if options[:json_header] != false
      # Format return
      content = {
        :header => {
          :version => current_version.to_s,
          :status => status,
          :request => request.original_fullpath, # escape or stripslahes or sanitize
        },
        :response => content
      }

      # If env is not production, return current env
      content[:header].merge!({:env => Rails.env}) unless Rails.env.production?
    end

    # Bug fix
    if request.method != 'GET'
      options[:location] ||= nil
    end

    super(content, options)
  end

private

  # Set default response format
  def set_default_response_format
    request.format = :json unless params[:format]
  end

  # Catch controller exceptions to show a formated message with good format
  def catch_exceptions
    yield
  rescue ActiveRecord::RecordNotFound
    render_record_not_found
  rescue ActiveRecord::RecordInvalid => e
    render_error e.message, 400
  rescue Exception => e
    Rails.logger.debug e.inspect
    Rails.logger.debug e.message.inspect
    e.backtrace.each {|l| Rails.logger.debug l.inspect }
    render_error e.message
  end

  # Render with error message
  def render_error(msg, code=500)
    respond_with(nil, :status => {:msg => msg, :code => code})
  end

  # Render with not found message
  def render_record_not_found
    record_name = !controller_name.blank? ? controller_name.singularize.titleize : "Record"
    respond_with(nil, :status => {:msg => "#{record_name} not found", :code => 404})
  end

end
