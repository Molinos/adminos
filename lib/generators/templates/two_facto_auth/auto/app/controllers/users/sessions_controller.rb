class Users::SessionsController < Devise::SessionsController
  include AuthenticatesWithTwoFactor

  prepend_before_action :authenticate_with_two_factor, only: [:create]
end
