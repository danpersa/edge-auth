module EdgeAuth
  module Concerns
    module SessionsController
      extend ActiveSupport::Concern
     
      # 'included do' causes the included code to be evaluated in the
      # conext where it is included (sessions_controller.rb), rather than be
      # executed in the module's context.
      included do
      end
     
      def new
        @title = 'Sign in'
      end

      def create
        user = User.authenticate(params[:session][:email],
                                 params[:session][:password])
        if user.nil?
          flash.now[:error] = 'Invalid email/password combination!'
          @title = 'Sign in'
          render 'new'
        elsif (!user.activated?)
          activate_user
        else
          # Sign the user in and redirect to the user's home page.
          sign_in user
          redirect_back_or main_app.root_path
        end
      end

      def destroy
        sign_out
        redirect_to root_path
      end
     
      module ClassMethods
      end
    end
  end
end