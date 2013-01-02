class DefaultController < ApplicationController
  session :disabled => true
  skip_before_filter :verify_authenticity_token

  def not_found
    res = {:msg => "Page not found"}
    respond_to do |format|
        format.html do
          @path = params[:path]
          render(:not_found, :layout => false, :status => 404)
        end
        format.xml  { render(:xml => res.to_xml, :status => 404) }
        format.json { render(:json => res.to_json, :status => 404) }
      end
  end

end
