module AuthenticatesWithTwoFactor
  extend ActiveSupport::Concern
  def authenticate_with_two_factor
    devise_parameter_sanitizer.permit(:sign_in, keys: [:otp_attempt])

    # remove otp_user_id if new login
    cookies.delete :otp_user_id if sign_in_params[:email]

    try_set_otp_user_id
    try_sign_in_user
  end

  private

  def try_set_otp_user_id
    user = User.find_by_email(sign_in_params[:email])

    return unless user&.otp_required_for_login
    return unless user.valid_password?(sign_in_params[:password])

    cookies.signed[:otp_user_id] = { value: user.id, expires: 5.minutes.from_now }
  end

  def try_sign_in_user
    user = User.find_by(id: cookies.signed[:otp_user_id])

    return unless user

    if user.current_otp == sign_in_params[:otp_attempt]
      sign_in(user)
    else
      self.resource = User.new
      render 'devise/sessions/two_factor'
    end
  end
end
