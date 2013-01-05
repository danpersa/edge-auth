class UsersController < EdgeAuth::ApplicationController
  include EdgeAuth::Concerns::UsersController
  include RecaptchaHelper
end