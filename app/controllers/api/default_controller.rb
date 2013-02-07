class Api::DefaultController < Api::BaseController
  skip_before_filter :verify_authenticity_token

  def not_found
    respond_with(nil, :status => {:msg => "Route not found", :code => 404})
  end

end
