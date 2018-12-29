    config.to_prepare do
      Devise::SessionsController.layout 'admin'
      Devise::RegistrationsController.layout proc { |controller| user_signed_in? ? 'application' : 'admin' }
      Devise::ConfirmationsController.layout 'admin'
      Devise::UnlocksController.layout 'admin'
      Devise::PasswordsController.layout 'admin'
    end
