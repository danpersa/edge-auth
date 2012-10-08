class UsersController < EdgeAuth::ApplicationController
  include EdgeAuth::Concerns::Users
  include RecaptchaHelper
end