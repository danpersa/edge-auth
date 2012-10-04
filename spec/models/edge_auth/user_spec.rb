require 'spec_helper'

describe EdgeAuth::User do
  before(:each) do
    @attr = {
      :email => 'user@example.com',
      :password => 'foobar',
      :password_confirmation => 'foobar'
    }
  end

  describe 'creation' do
    let(:user) do
      FactoryGirl.build(:user)
    end

    it 'should create a new instance given valid attributes' do
      user.save.should == true
    end
  end

  describe 'field validation' do

    describe 'email field' do
      it 'should reject invalid email addresses' do
        addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
        addresses.each do |address|
          invalid_email_user = FactoryGirl.build(:user, :email => address)
          invalid_email_user.should_not be_valid
        end
      end

      it 'should reject email addresses identical up to case' do
        user = FactoryGirl.create(:user)
        upcased_email = user.email.upcase
        user_with_duplicate_email = FactoryGirl.build(:user, :email => upcased_email)
        user_with_duplicate_email.should_not be_valid
      end

      describe 'when validating length' do

        context 'too long' do
          let(:user) do
            FactoryGirl.build(:user, email: 'a' * 256 + '@yahoo.com')
          end

          before do
            user.valid?
          end

          it 'should be shorter than 255 characters' do
            user.errors[:email].should == [ 'is too long (maximum is 255 characters)' ]
          end
        end
      end

      context 'when validating email presence' do
        let(:user) do
          FactoryGirl.build(:user, email: nil)
        end

        before do
          user.valid?
        end

        it 'should be provided' do
          user.errors[:email].first.should == 'can\'t be blank'
        end
      end

      context 'when validating email uniqueness' do
        let(:user) do
          FactoryGirl.build(:user, :email => 'same@example.com')
        end

        before do
          FactoryGirl.create(:user, :email => 'same@example.com')
          user.valid?
        end

        it 'should be unique' do
          user.errors[:email].should == [ 'is already taken' ]
        end
      end
    end

    describe 'state field' do

      context 'when validating inclusion' do
        let(:user) do
          FactoryGirl.build(:user, state: 'other')
        end

        before do
          user.valid?
        end

        it 'should be in the permitted states' do
          user.errors[:state].should == [ 'is not included in the list' ]
        end
      end

      describe 'states' do
        let(:user) do
          EdgeAuth::User.create!(@attr)
        end

        it 'should have an activation code' do
          user.activation_code.should_not be_empty
        end

        it 'should not be activated' do
          user.activated?.should == false
        end

        it 'should be created in the pending state' do
          user.state.should == 'pending'
        end

        it 'should switch to active state and be activated' do
          user.activate!
          user.state.should == 'active'
          user.activated?.should == true
        end

        it 'should not change password' do
          user.activate!
          user.password.should_not be_blank
        end
      end

      describe 'block user' do
        let(:user) do
          FactoryGirl.build(:user)
        end

        it 'should be in the blocked state' do
          user.block!
          user.state.should == 'blocked'
        end
      end
    end

    describe 'password field' do
      context 'when validating password confirmation' do
        let(:user) do
          FactoryGirl.build(:user, password_confirmation: 'invalid')
        end

        before do
          user.valid?
        end

        it 'should have a password confirmation' do
          user.errors[:password].should == ['doesn\'t match confirmation']
        end
      end

      # it_should_behave_like 'password validation' do
      #   let(:action) do
      #     @valid_object = Factory.build(:user)
      #   end
      # end

      describe 'password encryption' do

        let(:user) do
          FactoryGirl.create(:user)
        end

        it 'should have an encrypted password attribute' do
          user.should respond_to(:encrypted_password)
        end

        it 'should set the encrypted password' do
          user.encrypted_password.should_not be_blank
        end

        describe 'has_password? method' do

          it 'should be true if the passwords match' do
            user.has_password?(@attr[:password]).should be_true
          end

          it 'should be false if the passwords don\'t match' do
            user.has_password?('invalid').should be_false
          end
        end

        describe 'authenticate method' do

          it 'should return nil on email/password mismatch' do
            wrong_password_user = EdgeAuth::User.authenticate(@attr[:email], 'wrongpass')
            wrong_password_user.should be_nil
          end

          it 'should return nil if user is blocked' do
            blocked_user = FactoryGirl.create(:user, :email => 'blocked@yahoo.com')
            blocked_user.block!
            blocked_user = EdgeAuth::User.authenticate(blocked_user.email, blocked_user.password)
            blocked_user.should be_nil
          end

          it 'should return nil for an email address with no user' do
            nonexistent_user = EdgeAuth::User.authenticate('bar@foo.com', @attr[:password])
            nonexistent_user.should be_nil
          end

          it 'should return the user on email/password match' do
            matching_user = EdgeAuth::User.authenticate(@attr[:email], @attr[:password])
            matching_user.should == @user
          end
        end
      end
    end
  end
end
