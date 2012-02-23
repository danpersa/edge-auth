class IdentitiesController < ApplicationController

  def new
    @auth_form_model = EdgeAuth::Identity.new
    @auth_form_options = {}
  end

  def create
  	@auth_form_options = {}
  	@auth_form_model = EdgeAuth::Identity.new(params[:identity])

  	unless EdgeAuth::verify_recaptcha(request.remote_ip, params)
      @title = 'Sign up'
      # we trigger the validation manually
      @auth_form_model.valid?
      @auth_form_model.errors[:recaptcha] = 'The CAPTCHA solution was incorrect. Please re-try'
      render :new
      return
    end

    if @auth_form_model.valid?
      flash[:success] = "Please follow the steps from the email we sent you to activate your account!!"
      redirect_to root_path
    else
      @title = "Sign up"
      render :new
    end
  end


end
