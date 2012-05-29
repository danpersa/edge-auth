require 'spec_helper'

describe EdgeAuth::Identity do
  before(:each) do
    @attr = {
      :email => 'identity@example.com',
      :password => 'foobar',
      :password_confirmation => 'foobar'
    }
  end

  describe 'creation' do
    let(:identity) do
      FactoryGirl.build(:identity)
    end

    it 'should create a new instance given valid attributes' do
      identity.save.should == true
    end
  end

  describe 'field validation' do

    describe 'email field' do
      it 'should reject invalid email addresses' do
        addresses = %w[identity@foo,com identity_at_foo.org example.identity@foo.]
        addresses.each do |address|
          invalid_email_identity = FactoryGirl.build(:identity, :email => address)
          invalid_email_identity.should_not be_valid
        end
      end

      it 'should reject email addresses identical up to case' do
        identity = FactoryGirl.create(:identity)
        upcased_email = identity.email.upcase
        identity_with_duplicate_email = FactoryGirl.build(:identity, :email => upcased_email)
        identity_with_duplicate_email.should_not be_valid
      end

      describe 'when validating length' do

        context 'too long' do
          let(:identity) do
            FactoryGirl.build(:identity, email: 'a' * 256 + '@yahoo.com')
          end

          before do
            identity.valid?
          end

          it 'should be shorter than 255 characters' do
            identity.errors[:email].should == [ 'is too long (maximum is 255 characters)' ]
          end
        end
      end

      context 'when validating email presence' do
        let(:identity) do
          FactoryGirl.build(:identity, email: nil)
        end

        before do
          identity.valid?
        end

        it 'should be provided' do
          identity.errors[:email].first.should == 'can\'t be blank'
        end
      end

      context 'when validating email uniqueness' do
        let(:identity) do
          FactoryGirl.build(:identity, :email => 'same@example.com')
        end

        before do
          FactoryGirl.create(:identity, :email => 'same@example.com')
          identity.valid?
        end

        it 'should be unique' do
          identity.errors[:email].should == [ 'is already taken' ]
        end
      end
    end

    describe 'state field' do

      context 'when validating inclusion' do
        let(:identity) do
          FactoryGirl.build(:identity, state: 'other')
        end

        before do
          identity.valid?
        end

        it 'should be in the permitted states' do
          identity.errors[:state].should == [ 'is not included in the list' ]
        end
      end

      describe 'states' do
        let(:identity) do
          EdgeAuth::Identity.create!(@attr)
        end

        it 'should have an activation code' do
          identity.activation_code.should_not be_empty
        end

        it 'should not be activated' do
          identity.activated?.should == false
        end

        it 'should be created in the pending state' do
          identity.state.should == 'pending'
        end

        it 'should switch to active state and be activated' do
          identity.activate!
          identity.state.should == 'active'
          identity.activated?.should == true
        end

        it 'should not change password' do
          identity.activate!
          identity.password.should_not be_blank
        end
      end

      describe 'block identity' do
        let(:identity) do
          FactoryGirl.build(:identity)
        end

        it 'should be in the blocked state' do
          identity.block!
          identity.state.should == 'blocked'
        end
      end
    end

    describe 'password field' do
      context 'when validating password confirmation' do
        let(:identity) do
          FactoryGirl.build(:identity, password_confirmation: 'invalid')
        end

        before do
          identity.valid?
        end

        it 'should have a password confirmation' do
          identity.errors[:password].should == ['doesn\'t match confirmation']
        end
      end

      # it_should_behave_like 'password validation' do
      #   let(:action) do
      #     @valid_object = Factory.build(:identity)
      #   end
      # end

      describe 'password encryption' do

        let(:identity) do
          FactoryGirl.create(:identity)
        end

        it 'should have an encrypted password attribute' do
          identity.should respond_to(:encrypted_password)
        end

        it 'should set the encrypted password' do
          identity.encrypted_password.should_not be_blank
        end

        describe 'has_password? method' do

          it 'should be true if the passwords match' do
            identity.has_password?(@attr[:password]).should be_true
          end

          it 'should be false if the passwords don\'t match' do
            identity.has_password?('invalid').should be_false
          end
        end

        describe 'authenticate method' do

          it 'should return nil on email/password mismatch' do
            wrong_password_identity = EdgeAuth::Identity.authenticate(@attr[:email], 'wrongpass')
            wrong_password_identity.should be_nil
          end

          it 'should return nil if identity is blocked' do
            blocked_identity = FactoryGirl.create(:identity, :email => 'blocked@yahoo.com')
            blocked_identity.block!
            blocked_identity = EdgeAuth::Identity.authenticate(blocked_identity.email, blocked_identity.password)
            blocked_identity.should be_nil
          end

          it 'should return nil for an email address with no identity' do
            nonexistent_identity = EdgeAuth::Identity.authenticate('bar@foo.com', @attr[:password])
            nonexistent_identity.should be_nil
          end

          it 'should return the identity on email/password match' do
            matching_identity = EdgeAuth::Identity.authenticate(@attr[:email], @attr[:password])
            matching_identity.should == @identity
          end
        end
      end
    end
  end
end
