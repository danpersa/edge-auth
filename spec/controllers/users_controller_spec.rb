require 'spec_helper'

describe UsersController do
  render_views

  before(:each) do
    # Define @base_title here.
    @base_title = 'Remind me to live'
  end

  describe 'access control' do

    describe 'authentication' do

      it_should_behave_like 'deny access unless signed in' do
        let(:request_action) do
          post :update, :id => 1
        end
      end

      it_should_behave_like 'deny access unless signed in' do
        let(:request_action) do
          delete :destroy, :id => 1
        end
      end
    end
  end

  describe 'POST create' do

    describe 'failure' do

      before(:each) do
        @attr = { :username => '', :email => '', :password => '',
                  :password_confirmation => '' }
      end

      it 'should not create a user' do
        lambda do
          post :create, :user => @attr
        end.should_not change(EdgeAuth::User, :count)
      end

      it 'should render the new page' do
        post :create, :user => @attr
        response.should render_template :new
      end
      
      it 'should not send any mail' do
        ActionMailer::Base.deliveries = []
        post :create, :user => @attr
        ActionMailer::Base.deliveries.should be_empty
      end
      
      it 'should validate the password' do
        @attr = { :username => 'New Name', :email => 'user@example.org',
                  :password => 'barbaz', :password_confirmation => 'barbaz1' }
        post :create, :user => @attr
        response.should render_template :new
      end
    end

    describe 'success' do

      before(:each) do
        @attr = { :username => 'New EdgeAuth::User', :email => 'user@example.com',
                  :password => 'foobar', :password_confirmation => 'foobar' }
      end

      it 'should create a user' do
        lambda do
          post :create, :user => @attr
        end.should change(EdgeAuth::User, :count).by(1)
      end

      it 'should redirect to the signin page' do
        post :create, :user => @attr
        response.should redirect_to(signin_path)
      end

      it 'should have a welcome message' do
        post :create, :user => @attr
        flash[:success].should =~ /please follow the steps from the email we sent you to activate your account/i
      end

      it 'should NOT sign the user in' do
        post :create, :user => @attr
        controller.should_not be_signed_in
      end

      describe 'mail sending after registration' do
        before do
          ActionMailer::Base.deliveries = []
          Mongoid.observers = EdgeAuth::UserObserver
          Mongoid.instantiate_observers
        end

        it 'should send registration confirmation any mail' do
          post :create, :user => @attr
          ActionMailer::Base.deliveries.should_not be_empty
          email = ActionMailer::Base.deliveries.last
          email.to.should == [@attr[:email]]
        end
      end
    end
  end

  describe 'PUT update' do

    before(:each) do
      @user = FactoryGirl.create(:activated_user)
      test_sign_in(@user)
    end

    describe 'failure' do

      before(:each) do
        @attr = { :email => '' }
      end

      context 'when blank email' do
        it 'should render the edit page' do
          put :update, :id => @user.id, :user => @attr.merge(:username => 'danix')
          response.should render_template :edit
        end
      end      

    end

    describe 'success' do

      before(:each) do
        @attr = { :email => 'user@example.org',
                  :password => 'barbaz', :password_confirmation => 'barbaz' }
      end

      it 'should change the user\'s attributes' do
        put :update, :id => @user, :user => @attr
        @user.reload
        @user.email.should == @attr[:email]
      end
      
      it 'should not change the user\'s password' do
        put :update, :id => @user, :user => @attr
        @user.reload
        @user.has_password?('foobar').should == true
      end

      it 'should redirect to the user show page' do
        put :update, :id => @user, :user => @attr
        response.should redirect_to(user_path(@user))
      end

      it 'should have a flash message' do
        put :update, :id => @user, :user => @attr
        flash[:success].should =~ /updated/
      end
    end
  end

  describe 'authentication of update page' do

    before(:each) do
      @user = FactoryGirl.create(:unique_user)
    end

    describe 'for non-signed-in users' do

      it_should_behave_like 'deny access unless signed in' do
        let(:request_action) do
          put :update, :id => @user, :user => {}
        end
      end
    end

    describe 'for signed-in users' do

      before(:each) do
        wrong_user = FactoryGirl.create(:unique_user)
        test_sign_in(wrong_user)
      end

      it 'should require matching users for update' do
        put :update, :id => @user, :user => {}
        response.should redirect_to(root_path)
      end
    end
  end

  describe 'DELETE destroy' do

    before(:each) do
      @user = FactoryGirl.create(:unique_user)
    end

    describe 'as a non-admin user' do
      it 'should protect the page if the user tries to delete other user\'s account' do
        test_sign_in(@user)
        other_user = FactoryGirl.create(:unique_user)
        delete :destroy, :id => other_user.id
        response.should redirect_to(root_path)
      end
      
      it 'should allow access if the user tries to delete his own account' do
        test_sign_in(@user)
        delete :destroy, :id => @user.id
        response.should redirect_to(root_path)
      end
    end
  end

  describe 'GET activate' do
    
    before(:each) do
      @user = FactoryGirl.create(:unique_user)
    end
    
    describe 'when signed in' do
      it 'should redirect to profile if correct activation code' do
        test_sign_in(@user)
        get :activate, :activation_code => @user.activation_code
        response.should redirect_to(users_path + "/#{@user.id}")
      end
      
      it 'should redirect to profile if incorrect activation code or empty' do
        test_sign_in(@user)
        get :activate, :activation_code => 123
        response.should redirect_to(users_path + "/#{@user.id}")
      end
    end

    describe 'when not signed in' do
      
      describe 'when activation code is empty or not valid' do
        it 'should redirect to signin path' do
         get :activate, :activation_code => 123
         response.should redirect_to(signin_path)  
        end
      end

      describe 'when the user is already activated' do

        it 'should render an already activated user message' do
          test_activate_user(@user)
          get :activate, :activation_code => @user.activation_code
          @user.reload
          @user.activated?.should be_true
          response.should redirect_to(signin_path)
          flash[:notice].should =~ /Your account has already been activated!/i
        end  
      end
      
      describe 'when the user not is activated' do
        
        it 'should activate the user and redirect to home pabe' do
          get :activate, :activation_code => @user.activation_code
          @user.reload
          @user.activated?.should be_true
          response.should redirect_to(root_path)
        end
      end
    end
  end
end