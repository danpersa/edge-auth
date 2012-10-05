require 'rails'
require "edge-auth/engine"

module EdgeAuth

  module Controllers
    autoload :Controllers, 'edge-auth/controllers/sessions_concern'
  end

  #try and verify the captcha response. Then give out a message to flash
  def self.verify_recaptcha(remote_ip, params)
    
    unless EdgeCaptcha::Engine.config.recaptcha[:enable]
      return true
    end

    responce = Net::HTTP.post_form(URI.parse(EdgeCaptcha::Engine.config.recaptcha[:api_server_url]),
      { :privatekey => EdgeCaptcha::Engine.config.recaptcha[:private_key],
        :remoteip => remote_ip,
        :challenge => params[:recaptcha_challenge_field],
        :response => params[:recaptcha_response_field] })
      
    result = { :status => responce.body.split("\n")[0], 
               :error_code => responce.body.split("\n")[1] }

    if result[:error_code] == "incorrect-captcha-sol"
      return false
    elsif result[:error_code] == 'success'
      return true
    else
      flash[:alert] = "There has been a unexpected error with the application. Please contact the administrator. error code: #{result[:error_code]}"
      return false
    end
    return true
  end
end
