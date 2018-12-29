class AuthenticationsController < Devise::OmniauthCallbacksController
  def callback
    if current_user
      create_auth_for_current_user
    elsif found_auth
      sign_in_found_auth
    elsif matching_user
      create_auth_and_sign_in_matching_user
    else
      create_user_and_sign_in
    end
  end

  alias twitter   callback
  alias facebook  callback
  alias vkontakte callback
  alias google    callback

  def link
    user = User.find_by_email params[:email].try(:downcase)
    return head 401 unless user && user.valid_password?(params[:password])

    if (auth = current_user.authentications.first)
      flash[:notice] = t('social.bind_success', provider: auth.provider.capitalize)
    end

    cookies.delete :link_auth_modal
    auth.update_attribute :user, user
    current_user.destroy

    sign_in :user, user
    head :ok
  end

  private

  def omni
    request.env['omniauth.auth'].except('extra')
  end

  def omni_key
    @omni_key ||= { provider: omni.provider, uid: omni.uid.to_s }
  end

  def omni_key_with_nickname
    omni_key.merge(nickname: omni.info.nickname)
  end

  def found_auth
    @found_auth ||= Authentication.where(omni_key).first
  end

  def new_auth
    @new_auth ||= Authentication.new params[:authentication] || omni_key
  end

  def matching_user
    @matching_user ||= begin
      if omni.info.email
        User.find_by_email omni.info.email.downcase
      end
    end
  end

  def create_auth_for_current_user
    if found_auth
      flash[:alert] = t('social.already_bound')
      redirect_to :root
    else
      current_user.authentications.create! omni_key_with_nickname
      flash[:notice] = t('social.bind_success', provider: found_auth.provider.capitalize)
      redirect_to :root
    end
  end

  def sign_in_found_auth
    flash[:notice] = t('social.login_success', provider: found_auth.provider.capitalize)
    sign_in_and_redirect found_auth.user, event: :authentication
  end

  def create_auth_and_sign_in_matching_user
    new_auth.update_attribute :user, matching_user
    flash[:notice] = t('social.email_bind_success', provider: omni.provider.capitalize)
    sign_in_and_redirect new_auth.user, event: :authentication
  end

  def create_user_and_sign_in
    new_auth.build_user(email: omni.info.email)
    new_auth.save! validate: false

    cookies[:link_auth_modal] = true
    flash[:notice] = t('social.signup_success', provider: new_auth.provider.capitalize)
    sign_in_and_redirect new_auth.user, event: :authentication
  end
end
