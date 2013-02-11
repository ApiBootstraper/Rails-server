class Api::V100::BaseController < Api::BaseController
  # Set respond format
  respond_to :xml, :json

  # Set Filters
  before_filter :verify_application,
                :http_authenticate,
                :verif_format

protected

  #
  # Set and Get the current user
  #
  def current_user
    env['warden'].user
  end
  def set_current_user user
    env['warden'].set_user(user, :store => false)
  end

  # Params filter
  def params_filter params, filters
    return params unless filters.kind_of?(Array)
    return params unless params.kind_of?(Hash)
    res = {}
    filters.each { |k| res[k] = params[k] unless params[k].nil? }
    return res
  end

  # Before Filter for format
  def verif_format
    raise ActionController::RoutingError.new("Invalid format") unless ["json", "xml"].include? params[:format]
  end

  # Verify if application exists
  def verify_application
    # Verify Header
    env['tracking'].application = Application.enabled.find_by_app_id(request.headers["X-App-ID"])

    return respond_with(nil, :status => {:msg => "Invalid App-ID", :code => 405}) unless env['tracking'].application
  end

  def http_authenticate
    authenticate_or_request_with_http_basic("BASIC AUTH") do |email, password|
      user = User.api_v100_is_correct_user?(email, password)

      return respond_with(nil, :status => {:msg => "Authentication required", :code => 401}) if user.nil?

      @presenter.set_current_user = user unless @presenter.nil?
      set_current_user(user)
    end

  rescue Exception
    return respond_with(nil, :status => {:msg => "Authentication required", :code => 401})
  end
end