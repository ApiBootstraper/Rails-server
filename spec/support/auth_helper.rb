module AuthHelper
  def encode_credentials username, password
    # "Basic #{Base64.encode64("#{username}:#{password}")}"
    ActionController::HttpAuthentication::Basic.encode_credentials username, password
  end  
end