module EdgeAuth
  module Concerns
    module UsersController
      extend ActiveSupport::Concern

      included do
        before_filter :authenticate, :except => [:new, :create, :activate, :reset_password, :change_reseted_password]
        before_filter :activate_user, :except => [:show, :new, :create, :activate, :reset_password, :change_reseted_password]
        before_filter :existing_user, :only => [:show, :edit, :update, :destroy]
        before_filter :correct_user, :only => [:edit, :update, :destroy]
        before_filter :not_authenticate, :only => [:change_reseted_password, :create, :new]

        respond_to :html, :js

        private 

          def existing_user
            @user = User.find(params[:id])
            redirect_to(root_path) unless not @user.nil?
          end

          def correct_user
            redirect_to(root_path) unless current_user?(@user)
          end
      end
     
      def new
        @auth_form_model = User.new
        @auth_form_options = {:builder => SupersizeFormBuilder}
        @title = "Sign up"
        render :layout => 'one_section_narrow'
      end

      def create
        @auth_form_options = {:builder => SupersizeFormBuilder}
        @auth_form_model = User.new(params[:user])
        unless verify_recaptcha(request.remote_ip, params)
          @title = 'Sign up'
          # we trigger the validation manually
          @auth_form_model.valid?
          @auth_form_model.errors[:recaptcha] = 'The CAPTCHA solution was incorrect. Please re-try'
          render :template => 'users/new', :layout => 'one_section_narrow'
          return
        end

        if @auth_form_model.save
          flash[:success] = "Please follow the steps from the email we sent you to activate your account!!"
          redirect_to signin_path
        else
          @title = "Sign up"
          render :template => 'users/new', :layout => 'one_section_narrow'
        end
      end

      def update
        # the user is searched in the existing_user before interceptor
        if @user.update_attributes(params[:user])
          flash[:success] = "Profile updated."
          redirect_to @user
        else
          @title = "Edit user"
          #init_default_sidebar
          render :edit
        end
      end

      def destroy
        if (current_user?(@user))
          delete_own_account = true
        end
        # the user is searched in the existing_user before interceptor
        @user.destroy
        if (delete_own_account)
          flash[:success] = "Your account was successfully deleted!"
          redirect_to root_path
        else
          flash[:success] = "User destroyed."
          redirect_to users_path
        end
      end

      def activate
        if signed_in?
          if !activated?
            deny_access("Please activate your account before before you sign in!")
            return
          else
           redirect_to current_user
           return
          end
        end
        activated_user = User.where('activation_code' => params[:activation_code]).first
        if activated_user != nil && !activated_user.activated?
          activated_user.activate!
          sign_in activated_user
          flash[:success] = "Welcome to Remind Me To Live!"
          redirect_to root_path
          return
        end
        if activated_user != nil && activated_user.activated?
          deny_access("Your account has already been activated!")
          return
        end
        redirect_to signin_path
      end
     
      module ClassMethods
      end
    end
  end
end