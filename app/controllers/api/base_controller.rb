class Api::BaseController < ApplicationController
  session :disabled => true

  # Set filters
  skip_before_filter :verify_authenticity_token
  before_filter :set_default_response_format,
                :generate_presenter,
                :set_localization
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

  # Return a formated response
  def respond_with(content, *resources)
    options = resources.size == 0 ? {} : resources.extract_options!

    # if options[:response_header] != false && !content[:header].nil?
    #   content[:header].merge!({
    #     :version => current_version.to_s,
    #   })
    # end

    super(content, options)
  end

private

  # Set default response format
  def set_default_response_format
    request.format = :json unless params[:format]
  end

  def set_localization
    lang = nil
    if user_signed_in?
      lang = find_language(current_user.language)
    end
    if lang.nil? && request.env['HTTP_ACCEPT_LANGUAGE']
      accept_lang = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
      if !accept_lang.blank?
        accept_lang = accept_lang.downcase
      end
    end
    lang ||= Rails.application.config.i18n.default_locale
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
    e.backtrace.each { |l| Rails.logger.debug l.inspect }
    render_error e.message
  end

end
