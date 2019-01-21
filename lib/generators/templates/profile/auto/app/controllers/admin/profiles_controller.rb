class Admin::ProfilesController < Admin::BaseController
  load_and_authorize_resource param_method: :strong_params, class: User

  def update
    if resource.update_with_password(strong_params)
      flash[:notice] = t 'flash.actions.update.notice'
      redirect_to action: :edit
    else
      flash[:error] = t 'flash.actions.update.alert'
      render action: :edit
    end
  end

  private

  def resource
    @resource ||= current_user
  end

  helper_method :resource

  def strong_params
    params.require(:user).permit :email, :password, :password_confirmation,
                                 :current_password
  end
end
