module Adminos::Controllers::AdminExtension
  def batch_action
    objects = resource_class.where(id: params[:id_eq])
    if objects.empty?
      flash[:error] = I18n.t('flash.actions.batch_action.none')
      redirect_to url_for(action: :index)
    else
      objects.destroy_all                if params[:destroy]
      objects.set_each_published_off     if params[:set_published_off]
      objects.set_each_published_on      if params[:set_published_on]
      objects.set_each_nav_published_off if params[:set_nav_published_off]
      objects.set_each_nav_published_on  if params[:set_nav_published_on]
      flash[:notice] = I18n.t('flash.actions.batch_action.notice')
      redirect_to url_for(action: :index)
    end
  end

  def drop
    resource.place_to(params[:parent_id], params[:prev_id])
    resource.reload
    respond_to do |format|
      format.html { redirect_to action: :index }
      format.js { render layout: false }
    end
  end

  def duplication
    resource.duplication
    resource.reload
    respond_to do |format|
      format.html { redirect_to action: :index }
    end
  end
end
