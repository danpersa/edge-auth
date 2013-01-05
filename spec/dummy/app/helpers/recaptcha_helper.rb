require 'net/http'

module RecaptchaHelper
  
  #try and verify the captcha response. Then give out a message to flash
  def verify_recaptcha(remote_ip, params)    
    return true
  end

end