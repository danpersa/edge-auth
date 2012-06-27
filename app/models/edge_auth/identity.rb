require 'mongoid/edge-state-machine'

module EdgeAuth
  class Identity
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::EdgeStateMachine


    field :email                       , :type => String
    field :encrypted_password          , :type => String
    field :salt                        , :type => String
    field :state                       , :type => String
    field :activation_code             , :type => String
    field :activated_at                , :type => DateTime
    field :password_reset_code         , :type => String
    field :reset_password_mail_sent_at , :type => DateTime

    attr_accessor   :password, :updating_password
    attr_accessible :email, :password, :password_confirmation, :activation_code

    validates_presence_of       :email
    validates_length_of         :email, maximum: 255
    validates_uniqueness_of     :email, case_sensitive: false
    validates_format_of         :email, with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

    validates_presence_of       :password, :if => :should_validate_password?
    validates_confirmation_of   :password, :if => :should_validate_password?
    validates_length_of         :password, minimum: 6, maximum: 40, :if => :should_validate_password?

    before_save :encrypt_password
    before_create :make_activation_code

    state_machine do
    state :pending
      state :active
      state :blocked # the user in this state can't sign in

      event :activate do
        transition :from => [:pending], :to => :active, :on_transition => :do_activate
      end

      event :block do
        transition :from => [:pending, :active], :to => :blocked
      end
    end

    # Return true if the user's password matches the submitted password.
    def has_password?(submitted_password)
      encrypted_password == encrypt(submitted_password)
    end

    def self.authenticate(email, submitted_password)
      user = Identity.where(email: email).first
      return nil  if user.nil? or user.state == "blocked"
      return user if user.has_password?(submitted_password)
    end

    def self.authenticate_with_salt(id, cookie_salt)
      return nil if id.nil?
      user = Identity.where(_id: id).first
      (user && user.salt == cookie_salt) ? user : nil
    end

    def activated?
      if self.activated_at == nil
        return false
      end
      return true
    end

    def reset_password_expired?
      return self.reset_password_mail_sent_at < 1.day.ago
    end

    def reset_password
      self.password_reset_code = generate_token
      self.reset_password_mail_sent_at = Time.now.utc
      self.save!(validate: false)

    end

    def self.find_by_password_reset_code password_reset_code
      self.where(password_reset_code: password_reset_code).first 
    end

    def self.find_by_email email
      self.where(email: email).first
    end

    def do_activate
      self.activated_at = Time.now.utc
      self.save!
    end
  private

    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password) if should_validate_password?
    end

    def encrypt(s)
      secure_hash("#{salt}--#{s}")
    end

    def make_salt
      begin
        salt = secure_hash("#{Time.now.utc}--#{password}--#{SecureRandom.urlsafe_base64}")
        user = Identity.where(salt: salt)
      end while Identity.where({ salt: salt }).exists?
      return salt
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end

    def make_activation_code
      self.activation_code = generate_token
    end

    def should_validate_password?
      updating_password || new_record?
    end

    def generate_token
      Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
    end
  end
end