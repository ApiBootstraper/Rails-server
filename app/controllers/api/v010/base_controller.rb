class Api::V010::BaseController < Api::BaseController
  # Set respond format
  respond_to :xml, :json

  # Set Filters
  before_filter :http_authenticate,
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

  #
  # Params filter
  #
  def params_filter params, filters
    return params unless filters.kind_of?(Array)
    return params unless params.kind_of?(Hash)
    res = {}
    filters.each { |k| res[k] = params[k] unless params[k].nil? }
    return res
  end

  #
  # Before Filter for format
  #
  def verif_format
    formats = ["json", "xml"]
    unless formats.include? params[:format]
      raise ActionController::RoutingError.new("Invalid format")
    end
  end

  def http_authenticate
    authenticate_or_request_with_http_basic("BASIC AUTH") do |email, password|
      user = User.api_v010_is_correct_user?(email, password)

      if user.nil?
        respond_with(nil, :status => {:msg => "Authentication required", :code => 401})
        return
      else
        set_current_user(user)
      end
    end

  rescue Exception
    respond_with(nil, :status => {:msg => "Authentication required", :code => 401})
    return
  end
end