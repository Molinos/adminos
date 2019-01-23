class Users::SessionsController < Devise::SessionsController
  prepend_before_action only: [:create] do
    verify_captcha!(new_user_session_path)
  end
end
